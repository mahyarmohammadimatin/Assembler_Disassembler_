%include "in_out.asm"

sys_makedir_access equ   0q777 ;system should get access for making directory(set in rsi)
open_dir equ 0q0200000 ;something for open directory(set in rsi)

section .data
	test_dir db "/home/mahyar/photo/p1.bmp", 0
	test_dir2 db "/home/mahyar/photo/edited_photo/p1.bmp", 0
  	edited_photo db "edited_photo/", 0
  	flg db 0
    
section .bss
	num resb 1

	dir resb 1000
	dir_dscp resq 1
	dir_len resq 1
	new_dir resb 1000
	file_path_source resb 1000
	file_path_dist resb 1000
	
	files_ptr resq 100000
	files_ptr_end resq 1
	
	;curent proccessing file info
	name resq 1 ;file name
	dscp resq 1 ;descriptor
	header_type resb 18 ;header and type of file
	img_header resb 36 ;36 for windows and 8 for os
	pix_arr resq 1000000 ;each row that we proccess
	width resq 1
	height resq 1
	size resq 1
	
	;new file info
	dscp_new resq 1
	
	st_size resq 1
	
section .text
    global _start
    
%macro concat_str 3 ;get str1,str2,dist and save str1+str2 in dist
	;copy first str
	mov rdi,%1
	call GetStrlen 
	mov rcx,rdx
	mov rsi,%1
	mov rdi,%3
	rep movsb 
	
	mov r8,rdx
	
	;copy second str
	mov rdi,%2
	call GetStrlen 
	mov rcx,rdx
	mov rsi,%2
	mov rdi,%3
	add rdi,r8
	rep movsb 
	
	mov byte [rdi],0
%endmacro

_start:
	;calc pix_arr_ptr to avoid segmentation(memory alignment)
	%define pix_arr_ptr r14
	xor rdx,rdx
	mov rax,pix_arr
	mov rbx,64
	idiv rbx
	sub rbx,rdx
	mov pix_arr_ptr,pix_arr
	add pix_arr_ptr,rbx
	
	;read from user
	push dir_len
	push dir
	call readString
	
	call readNum
	cmp al,0
	jl negative
	mov [num],al
	jmp next
	negative:
	mov byte[flg],1
	neg rax
	mov [num],al
	
	next:
	concat_str dir,edited_photo,new_dir
	
	call make_folder
	
   	call read_files_to_buffer
   	
   	;call process_file
Exit:
    mov rax,60
    xor rdi,rdi 
    syscall
    
read_files_to_buffer:
	mov rax,2
    	mov rdi,dir
    	mov rsi,open_dir                 
    	syscall
    	mov [dir_dscp],rax
    	
    	mov rdi,rax    
    	mov rax,217    ;getdent64 syscall         
    	mov rsi,files_ptr
    	mov rdx,1000000
    	syscall
    	
	add rax, files_ptr 
    	mov [files_ptr_end], rax ;end of buffer

    	;prepare loop
    	mov rax,files_ptr
    	mov [st_size],rax
    	xor r13,r13 ;iterator
    	
    	loop_on_dir_files:

    	    add r13, [st_size]
    	    cmp r13, [files_ptr_end]
    	    jge finish 
    	    
    	    xor rax, rax
            mov ax, [r13+16] ; size
            mov [st_size], rax
	     
            lea rax, [r13+18]
            xor rbx, rbx
            mov bl, [rax] ; file or directory
            cmp bl, 8 ; check for file
            jne loop_on_dir_files
            
            lea rax,[r13+19]
            concat_str dir,rax,file_path_source
            concat_str new_dir,rax,file_path_dist
	    
	    call process_file
	    
	    jmp loop_on_dir_files
	    
	finish:
            
    	ret
    
inc_parallel:
	mov rcx,0
	inc_loop:
		movdqa xmm1,[pix_arr_ptr+rcx]
		vpbroadcastb xmm2,[num]
		cmp byte[flg],1
		je sub
		vpaddusb xmm1,xmm2
		jmp next_plz
		sub:
		vpsubusb xmm1,xmm2
		next_plz:
		movdqa [pix_arr_ptr+rcx],xmm1
		add rcx,16
		cmp rcx,[size]
		jl inc_loop
	ret
    
read_pixel:
	%define row_bytes r8
	%define padding r9
	mov row_bytes, [width]
	imul row_bytes,3 ;row bytes now contain the number of bytes to read
	
	;calc padding
    	mov rax,row_bytes
    	xor rdx,rdx
    	mov rcx,4
    	idiv rcx
    	sub rcx,rdx
    	mov r15,0 ;just temperory
    	cmp rcx,4
    	cmove rcx,r15
    	mov padding,rcx
    	
    	
    	;calc pixel array size
    	mov rax,row_bytes
    	imul qword[height]
    	mov [size],rax
    	mov rax,[height]
    	imul padding
    	add [size],rax
    	
    	;read from file to pixel array
    	xor rax,rax
    	mov rdi,[dscp]
    	mov rsi,pix_arr_ptr                
    	mov rdx,[size]
    	syscall
    	
    	call inc_parallel
    	
    	;write to distination
    	mov rax,1
	mov rdi,[dscp_new]
    	mov rsi,pix_arr_ptr
    	mov rdx,[size]
    	syscall
    	
    	%undef row_bytes
	%undef padding
    	
    	ret
    	
process_file:
	;open curent file
	mov rax,2
    	mov rdi,file_path_source
    	mov rsi,O_RDWR
    	syscall
    	mov [dscp],rax
	;------------------
        ;read first 18 byte of file (14byte header+4byte type) 
    	xor rax,rax
    	mov rdi,[dscp]           
    	mov rsi,header_type
    	mov rdx,18
    	syscall
    	           
    	;check if file is bmp
    	mov ax,[header_type] ;first 2 byte should be 'BM'   
    	cmp ax,'BM'     
    	jne close_curent_file
    	
    	;create file
    	mov rax,85
    	mov rdi,file_path_dist
    	mov rsi,sys_IRUSR | sys_IWUSR
    	syscall
    	mov [dscp_new],rax
    
    	;write header and type on new file
    	mov rax,1
    	mov rdi,[dscp_new]
    	mov rsi,header_type
    	mov rdx,18
    	syscall
    	
    	;check type(os or windows)
    	xor rax,rax
    	mov eax,[header_type+14] ;mov type to eax
    	cmp eax,40 ;file type 40 is windows, else its os (file type 12)
    	je windows
    	jmp os

    	windows:
    	    xor rax,rax
	    mov rdi,[dscp]
	    mov rsi,img_header
	    mov rdx,36
	    syscall

	    ;save width and height(in windows mode each are 4byte)
	    xor rbx,rbx
	    xor rcx,rcx
	    mov ebx,[img_header]
	    mov [width],rbx
	    mov ecx,[img_header+4]
	    mov [height],rcx

	    ;write image header to new file
	    mov rax,1
	    mov rdi,[dscp_new]
	    mov rsi,img_header
	    mov rdx,36
	    syscall
	    jmp handle_pixel
    	os:
    	    xor rax,rax
	    mov rdi,[dscp]
	    mov rsi,img_header
	    mov rdx,8
	    syscall

	    ;save width and height(in os mode each are 2byte)
	    xor rbx,rbx
	    xor rcx,rcx
	    mov bx,[img_header]
	    mov [width],rbx
	    mov cx,[img_header+2]
	    mov [height],rcx
	    
	    ;write image header to new file
	    mov rax,1
	    mov rdi,[dscp_new]
	    mov rsi,img_header
	    mov rdx,8
	    syscall
	    jmp handle_pixel
	    
	handle_pixel:
	    call read_pixel
	    
	    ;close newfile
    	    mov rax,3
    	    mov rdi,[dscp_new]
    	    syscall
    	
	;------------------
	close_curent_file:
    	mov rax,3
    	mov rdi,[dscp]
    	syscall

    	ret
    

    
make_folder:
	mov rax,83 ;make directory systemcall
    	mov rdi,new_dir
	mov rsi,sys_makedir_access
	syscall
	ret

readString: ;(inputed_memory,len)  ;readString and save address in inputed memory and save size in len
	%define save_ad	[rbp+16]
	%define len	[rbp+24]
	enter	0, 0
	push	rcx
	push	rax
	push 	rsi
	;--------------------------------------------
	mov rsi,save_ad
	mov rcx,0
	read_char:
		call getc
		cmp al,0xA
		je bye_readString
		mov [rsi+rcx],al
		inc rcx
		jmp read_char
	
	;--------------------------------------------
	bye_readString:
	mov byte[rsi+rcx],0
	mov rax,len
	mov [rax],rcx
	%undef save_ad
	%undef len	
	pop 	rsi
	pop	rax
	pop	rcx
	leave
	ret 	16 ;don't forget to set this to the number of parameters
	
