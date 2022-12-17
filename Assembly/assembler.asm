%include "in_out.asm"
;%include "string.asm"
;%include "dictionary.asm"
;%include "constants.asm"
;%include "variables.asm"
;%include "file_macros.asm"

section .data
mahyar 	db	'mahyar',0
nana	db 	'nana',0
w_space	db	' ',0
two_colon db	':',0
comma	db	',',0
open_ber db	'[',0
close_ber db	']',0
plus	db	'+',0
star	db	'*',0
slash	db	'/',0
hex_0x 	db	'0x',0
zero_const db	'0000000000000000000000000000000000000000000000000000000000000000000000000000',0
one_const db	'1111111111111111111111111111111111111111111111111111111111111111111111111111',0
reg_str	db	'reg',0
mem_str	db	'mem',0
imm_str	db	'imm',0
bnum66  db	'01100110',0
bnum67  db	'01100111',0
num101	db	'101',0
num100	db	'100',0
num64	db	'64',0
num32	db	'32',0
num16	db	'16',0
num11	db	'11',0
num10	db	'10',0
num8	db	'8',0
num01	db	'01',0
num000	db	'000',0
num00	db	'00',0
num1	db	'1',0
num0	db	'0',0

;some oprands for handeling exceptions
bsf_str	db	'bsf',0
bsr_str	db	'bsr',0
imul_str db	'imul',0
xchg_str db	'xchg',0
inc_str db	'inc',0
test_str db	'test',0
bp_str	db	'bp',0
shl_str	db	'shl',0
shr_str	db	'shr',0
not_imp_n db	'N',0
not_imp	db	'sorry this order is not implemented yet :(',0
rex_code db	'0100',0

bin_file_str db 'bin_file.txt',0
hex_file_str db 'hex_file.txt',0

reg_code_list db ",rax:0000,rcx:0001,rdx:0010,rbx:0011,rsp:0100,rbp:0101,rsi:0110,rdi:0111,\
eax:0000,ecx:0001,edx:0010,ebx:0011,esp:0100,ebp:0101,esi:0110,edi:0111,\
ax:0000,cx:0001,dx:0010,bx:0011,sp:0100,bp:0101,si:0110,di:0111,\
al:0000,cl:0001,dl:0010,bl:0011,ah:0100,ch:0101,dh:0110,bh:0111,\
r8:1000,r9:1001,r10:1010,r11:1011,r12:1100,r13:1101,r14:1110,r15:1111,\
r8d:1000,r9d:1001,r10d:1010,r11d:1011,r12d:1100,r13d:1101,r14d:1110,r15d:1111,\
r8w:1000,r9w:1001,r10w:1010,r11w:1011,r12w:1100,r13w:1101,r14w:1110,r15w:1111,\
r8b:1000,r9b:1001,r10b:1010,r11b:1011,r12b:1100,r13b:1101,r14b:1110,r15b:1111,",0

reg_mode_list db ",rax:64,rcx:64,rdx:64,rbx:64,rsp:64,rbp:64,rsi:64,rdi:64,\
eax:32,ecx:32,edx:32,ebx:32,esp:32,ebp:32,esi:32,edi:32,\
ax:16,cx:16,dx:16,bx:16,sp:16,bp:16,si:16,di:16,\
al:8,cl:8,dl:0010,bl:8,ah:8,ch:8,dh:8,bh:8,\
r8:64,r9:64,r10:64,r11:64,r12:64,r13:64,r14:64,r15:64,\
r8d:32,r9d:32,r10d:32,r11d:32,r12d:32,r13d:32,r14d:32,r15d:32,\
r8w:16,r9w:16,r10w:16,r11w:16,r12w:16,r13w:16,r14w:16,r15w:16,\
r8b:8,r9b:8,r10b:8,r11b:8,r12b:8,r13b:8,r14b:8,r15b:8,",0

one_oprand_op_list db ",inc:1111111,neg:1111011,not:1111011,idiv:1111011,dec:1111111,",0
one_oprand_reg_list db ",inc:000,neg:011,not:010,idiv:111,dec:001,",0

two_oprand_opcode_list 	db ",mov:100010,add:000000,adc:000100,sub:001010,sbb:000110,and:001000,or:000010,xor:001100,cmp:001110,\
test:100001,xchg:100001,xadd:00001111110000,bsf:00001111101111,bsr:00001111101111,imul:00001111101011,"

bin_to_hex_list db ",0000:0,0001:1,0010:2,0011:3,0100:4,0101:5,0110:6,0111:7,1000:8,1001:9,1010:A,1011:B,1100:C,1101:D,1110:E,1111:F,",0

hex_to_bin_list db ",0:0000,1:0001,2:0010,3:0011,4:0100,5:0101,6:0110,7:0111,8:1000,9:1001,a:1010,A:1010,b:1011,B:1011,c:1100,C:1100,d:1101,D:1101,e:1110,E:1110,f:1111,F:1111",0

zero_op_list db ",ret:11000011,stc:11111001,clc:11111000,std:11111101,cld:011111100,syscall:0000111100000101,",0

memory_size_list db ",BYTE:8,WORD:16,DWORD:32,QWORD:64,",0
scale_code_list db ",1:00,2:01,4:10,8:11,",0

section .bss

;some things should be initialize
rex_w 		resb 	20 ;rex_w	db	'0',0
rex_r 		resb 	20 ;rex_r	db	'0',0
rex_x 		resb 	20 ;rex_x	db	'0',0
rex_b 		resb 	20 ;rex_b	db	'0',0
code_w 		resb 	20 ;code_w	db	'0',0
MOD 		resb 	20 ;MOD		db	'00',0
REG 		resb 	20 ;REG		db	'000',0
RM 		resb 	20 ;RM		db	'000',0
check2 		resb 	20 ;check2	db	'0',0

;input parsing
inp   		resb 	200
oprand		resb	100
source 		resb 	100
dist		resb	100
source_type	resb	200
dist_type	resb	20
my_reg		resb	100
my_mem		resb	100

;memory section after input parsing
mem_size	resb	40
mem_disp	resb	40
mem_scale	resb 	40
mem_index	resb	40
mem_base	resb	40
mem_direct	resb	40 ;(mem_index==None and mem_base==None)

;sections of hex code
;prefixes
prefix66	resb 	65
prefix67 	resb	65
;rex bits are defined in data section
sticked_rex	resb	65
opcodeD		resb	65
;code_w is defined in data section
;MOD is defined in data section
;REG is defined in data section
;RM is defined in data section
;SIB
scale		resb	65
index		resb	65
base		resb	65
disp		resb	65
data		resb	65

;results
result_bin	resb	200
result_hex	resb 	200
result_inp_hex	resb	200

;temps
temp_dic	resb	200
temp_find	resb	200
temp_type	resb	200
temp_swap	resb	200
temp_disp_size	resb	200
temp_set_disp	resb	200
temp_set_disp_rev	resb	200
temp_hex_bin	resb	200
temp_hex_bin2	resb	200
ret_str 	resb 	200
temp		resb	200

;files
path		resb	200
folder_path	resb	200
bin_file_path	resb	200
hex_file_path	resb	200
main_file_desc	resb	200
bin_file_desc	resb	200
hex_file_desc	resb	200
buffer		resb	10000

;other
new_line_char	resb	2
    
section .text
    global _start

    
%macro push_all 0
	push rbx
	push rcx
	push rdx
	push rsi
	push rdi
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
%endmacro    

%macro pop_all 0
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx
%endmacro

%macro str_is_empty 1
	push_all
	mov r15,%1
	mov bl,byte[r15]
	cmp bl,0
	pop_all
%endmacro

%macro str_print 1
	push_all
	mov rsi,%1
	call printString
	call newLine
	pop_all
%endmacro

%macro str_swap 2
	push_all
	mov r15,%1
	mov r14,%2
	mov rbx,r15
	mov rcx,r14
	str_mov temp_swap,rbx
	str_mov	rbx,rcx
	str_mov rcx,temp_swap
	pop_all
%endmacro

%macro str_len 1
	push_all
	mov rdi,%1
	call GetStrlen
	mov rax,rdx
	pop_all
%endmacro
    
%macro str_concat 3 ;get str1,str2,dist and save str1+str2 in dist
	push_all
	mov r15,%1
	mov r14,%2
	mov r13,%3
	
	;copy first str
	mov rdi,r15
	call GetStrlen 
	mov rcx,rdx
	mov rsi,r15
	mov rdi,r13
	rep movsb 
	
	mov r8,rdx
	
	;copy second str
	mov rdi,r14
	call GetStrlen 
	mov rcx,rdx
	mov rsi,r14
	mov rdi,r13
	add rdi,r8
	rep movsb 
	
	mov byte [rdi],0
	
	pop_all
%endmacro

%macro str_is_equal 2 ;get 2 string and set zero flag if they are equal
	push_all
	mov r15,%1
	mov r14,%2
	
	mov rdi,r15
	call GetStrlen
	mov rax,rdx
	mov rdi,r14
	call GetStrlen
	cmp rax,rdx
	jne %%not_eq
	
	;if they are the same length check them
	lea rcx,[rax+1]
	mov rsi,r15
	mov rdi,r14
	repe cmpsb
	cmp rcx,0
	jne %%not_eq
	
	;so they are equal
	cmp rax,rax
	jmp %%exit_is_equal
	
	%%not_eq:
	cmp rcx,-2
	
	%%exit_is_equal:
	pop_all
%endmacro
    
%macro str_mov 2 ; get two string address and mov one to another
	push_all
	mov r15,%1
	mov r14,%2
	
	mov rdi,r14
	call GetStrlen
	lea rcx,[rdx+1]
	mov rdi,r15
	mov rsi,r14
	rep movsb
	
	pop_all
%endmacro 

%macro str_find 2 ;get 2 string and find second string in first(return index in rax)
	push_all
	mov r15,%1
	mov r14,%2
	%define iter r8
	%define s1_len r9
	%define s2_len r10
	mov rdi,r15
	call GetStrlen
	mov s1_len,rdx
	mov rdi,r14
	call GetStrlen
	mov s2_len,rdx
	cmp s1_len,s2_len
	jl %%dontfind
	
	mov rsi,r15
	mov rdi,r14
	
	mov iter,0
	
	%%str_find_loop:
		mov rsi,r15
		lea rax,[iter+s2_len]
		str_slicing rsi,iter,rax,temp_find
		mov rax,temp_find
		
		mov rdi,r14
		str_is_equal rax,rdi
		je %%finded
		
		inc iter
		lea rax,[iter+s2_len]
		cmp rax,s1_len
		jle %%str_find_loop
		
	%%dontfind:
		mov rax,-1
		jmp %%exit_str_find
	%%finded:
		mov rax,iter
		
	%%exit_str_find:
	pop_all
	%undef iter
	%undef s1_len
	%undef s2_len
%endmacro
   
%macro str_slicing 4 ;s,i,j,dist and return s[i:j] in dist
	push_all
	mov r15,%1
	mov r14,%2
	mov r13,%3
	mov r12,%4

	mov rdi,r15
	call GetStrlen ;len in rdx
	cmp r13,0
	jg %%str_slicing_next
	lea r13,[rdx+r13]
	%%str_slicing_next:
	cmp r14,r13
	je  %%empty_str
	
	mov rax,r15
	mov rdi,r12 ;start of dist
	lea rsi,[rax+r14] ;strat of slice
	mov rcx,r13
	mov rdx,r14
	sub rcx,rdx
	rep movsb
	mov byte[rdi],0
	jmp %%exit_str_slicing
	
	%%empty_str:
	mov byte[rdi+1],0
	
	%%exit_str_slicing:
	pop_all
%endmacro
   
readString: ;(inputed_memory)  ;readString and save address in inputed memory
	%define save_ad	[rbp+16]
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
	%undef save_ad
	pop 	rsi
	pop	rax
	pop	rcx
	leave
	ret 	8 ;don't forget to set this to the number of parameters
%macro openFile 1 ;get file path and open it
	push_all
	mov r15,%1
	mov rax, sys_open
	mov rsi, O_RDWR | O_CREAT | O_APPEND
	mov rdx, sys_IRUSR | sys_IWUSR
	mov rdi,r15
	syscall
	pop_all
%endmacro

%macro closeFile 1
    push_all
    mov r15,%1
    mov rdi,r15
    mov rax, sys_close
    syscall
    pop_all
%endmacro
    
%macro readFile 2 ;file desc and buffer inputed
	push_all
	mov rdi,%1
	mov rsi,%2
	mov rdx,10000
	mov rax,sys_read
	syscall
	pop_all
%endmacro

%macro get_folder_path 2
	push_all
	mov r15,%1
	mov r14,%2
	str_len r15
	lea rcx,[r15+rax-1]
	get_folder_path_loop:
		mov bl,byte[slash]
		cmp bl,byte[rcx]
		je find_slash
		loop get_folder_path_loop
	find_slash:
	sub rcx,r15 ;get index instead of address
	inc rcx ;to include slash
	mov rbx,r15
	mov rdx,r14
	str_slicing rbx,0,rcx,rdx
	pop_all
%endmacro

%macro writeFile 2
	push_all
	mov r15,%1
	mov r14,%2
	mov rdi,r15
	mov rsi,r14
	mov rbx,r14
	str_len rbx
	lea rdx,[rax]
	mov rax,sys_write
	syscall
	pop_all
%endmacro

%macro dic_get 3 ;get dictionary and key and pass value in dist
	push_all
	mov r15,%1
	mov r14,%2
	mov r13,%3
	
	mov rdx,r14
	str_concat comma,rdx,temp_dic
	str_concat temp_dic,two_colon,temp_dic
	mov rdx,r15
	str_find rdx,temp_dic

	mov rbx,rax ;start index of (key:value) in rbx
	str_len temp_dic
	add rbx,rax ;start index of value
	
	lea rax,[r15+rbx] ;start address of value
	str_find rax,comma
	add rax,rbx ;rbx+rax is index of end of value
	mov rdx,r15
	mov rcx,r13
	str_slicing rdx,rbx,rax,rcx
	
	pop_all
%endmacro

%macro get_type 2
	push_all
	mov r15,%1
	mov r14,%2
	
	mov rax,r15
	str_find rax,open_ber
	cmp rax,-1
	jne %%it_is_mem
	
	mov rax,r15
	str_concat rax,two_colon,temp_type
	str_find reg_code_list,temp_type
	cmp rax,-1
	je %%it_is_imm
	
	%%it_is_reg:
	mov rax,r14
	str_mov rax,reg_str
	jmp %%Exit_get_type
	
	%%it_is_imm:
	mov rax,r14
	str_mov rax,imm_str
	jmp %%Exit_get_type
	
	%%it_is_mem:
	mov rax,r14
	str_mov rax,mem_str
	jmp %%Exit_get_type
	
	%%Exit_get_type:
	pop_all
%endmacro

%macro reg_print 1
	push_all
	push rax
	mov rax,%1
	call writeNum
	call newLine
	pop rax
	pop_all
%endmacro

%macro get_disp_size 2
	push_all
	mov r15,%1
	mov r14,%2
	mov rbx,r15
	str_len rbx
	cmp rax,1
	je %%disp_size_set_01
	
	cmp rax,3
	jge %%disp_size_set_10
	
	str_slicing rbx,0,1,temp_disp_size ;a1 -> a
	dic_get hex_to_bin_list,temp_disp_size,temp_disp_size ;a -> 1010
	str_slicing temp_disp_size,0,1,temp_disp_size ;1010 -> 1
	str_is_equal temp_disp_size,num1
	je %%disp_size_set_10
	jmp %%disp_size_set_01
	
	%%disp_size_set_01:
	str_mov r14,num01
	jmp %%disp_size_finish
	
	%%disp_size_set_10:
	str_mov r14,num10
	
	%%disp_size_finish:
	pop_all
%endmacro

%macro set_disp 3 ;get mem_disp and MOD
	push_all
	mov r8,%1
	mov r9,%2
	mov r10,%3
	
	str_is_equal r9,num10
	je %%set_rbx_as_mod_8
	%%set_rbx_as_mod_2:
	mov rbx,2
	jmp %%set_disp_continue
	
	%%set_rbx_as_mod_8:
	mov rbx,8
	
	%%set_disp_continue:
	mov rcx,rbx
	str_len mem_disp
	sub rcx,rax
	cmp rcx,0
	je %%set_r8_in_r10
	str_slicing zero_const,0,rcx,temp_set_disp
	str_concat temp_set_disp,r8,r10
	jmp %%set_disp_next
	
	%%set_r8_in_r10:
	str_mov r10,r8
	
	%%set_disp_next:
	str_len r8
	mov rcx,rax ;iterstor from end -2 step for make hex reverse
	%%set_disp_reverse_loop: ;[res[i]+res[i+1] for i in range(0,len(res),2)].reverse()
		sub rcx,2
		cmp rcx,0
		jl %%set_disp_continue2
		lea rdx,[rcx+2]
		str_slicing r10,rcx,rdx,temp_set_disp
		str_concat temp_set_disp_rev,temp_set_disp,temp_set_disp_rev
		jmp %%set_disp_reverse_loop
		
	%%set_disp_continue2:
	str_mov r10,temp_set_disp_rev
	pop_all
%endmacro

%macro hex_to_bin 2
	push_all
	mov r15,%1
	mov r14,%2
	mov rcx,0
	mov byte[temp_hex_bin2],0
	%%hex_bin_loop:
		lea rdx,[rcx+1]
		mov rbx,r15
		str_slicing rbx,rcx,rdx,temp_hex_bin ;get hex digit
		dic_get hex_to_bin_list,temp_hex_bin,temp_hex_bin ;convert to 4 digit binary
		str_concat temp_hex_bin2,temp_hex_bin,temp_hex_bin2
		inc rcx
		str_len r15
		cmp rax,rcx
		jne %%hex_bin_loop
		
	str_mov r14,temp_hex_bin2
	pop_all
%endmacro



_start:
    call reset_data
    push path
    call readString
    
    openFile path
    mov [main_file_desc],rax
    
    get_folder_path path,folder_path
    
    str_concat folder_path,bin_file_str,bin_file_path
    str_concat folder_path,hex_file_str,hex_file_path
    
    openFile bin_file_path
    mov [bin_file_desc],rax
    openFile hex_file_path
    mov [hex_file_desc],rax
    
    ;read the entire file
    readFile [main_file_desc],buffer
    
    ;set newline char
    mov rax,new_line_char
    mov byte[rax],0xa
    mov byte[rax+1],0
    line_by_line_loop:
    	str_find buffer,new_line_char
    	mov rbx,rax
    	str_slicing buffer,0,rbx,inp
    	
    	
    	call assemmble
    	
    	call write_to_file
    	
    	call reset_data
    	
    	
    	str_find buffer,new_line_char
    	mov rbx,rax
    	str_slicing buffer,rbx,0,buffer
    	str_is_equal buffer,new_line_char ;if buffer read ends
        je close_files
        str_slicing buffer,1,0,buffer
        jmp line_by_line_loop
    
    
    close_files:
        closeFile [main_file_desc]
        closeFile [bin_file_desc]
        closeFile [hex_file_desc]
    

Exit:
    mov rax, 1
    mov rbx, 0 
    int 0x80
    
write_to_file:
	str_concat result_hex,w_space,result_inp_hex
    	str_concat result_inp_hex,inp,result_inp_hex
    	str_print result_inp_hex
    	str_concat result_inp_hex,new_line_char,result_inp_hex
    	writeFile [hex_file_desc],result_inp_hex
    	str_print result_bin
    	writeFile [bin_file_desc],result_bin
    	ret
    
reset_data:
	str_mov rex_w,num0
	str_mov rex_r,num0
	str_mov rex_x,num0
	str_mov rex_b,num0
	str_mov code_w,num0
	str_mov MOD,num00
	str_mov REG,num000
	str_mov RM,num000
	str_mov check2,num0
	mov byte[inp],0
	mov byte[oprand],0
	mov byte[source],0
	mov byte[dist],0
	mov byte[source_type],0
	mov byte[dist_type],0
	mov byte[my_reg],0
	mov byte[my_mem],0
	mov byte[mem_size],0
	mov byte[mem_disp],0
	mov byte[mem_scale],0
	mov byte[mem_index],0
	mov byte[mem_base],0
	mov byte[mem_direct],0
	mov byte[prefix66],0
	mov byte[prefix67],0
	mov byte[sticked_rex],0
	mov byte[opcodeD],0
	mov byte[scale],0
	mov byte[index],0
	mov byte[base],0
	mov byte[disp],0
	mov byte[data],0
	mov byte[result_bin],0
	mov byte[result_hex],0
	mov byte[temp_find],0
	mov byte[temp_type],0
	mov byte[temp_swap],0
	mov byte[temp_disp_size],0
	mov byte[temp_set_disp],0
	mov byte[temp_set_disp_rev],0
	mov byte[ret_str],0
	mov byte[temp],0
	mov byte[result_inp_hex],0
	ret
    
;--------------------------------------------------------------------------------------------------
;----------------------------------------main assembler--------------------------------------------
;-------------------------------------------------------------------------------------------------- 
;assemmble 'inp' and save result in result_bin and result_hex   
assemmble: 
push_all
;check if we have oprand
str_find inp,w_space
cmp rax,-1
je 	zero_oprand

;check for space at the end
mov rbx,rax ;first w_space index in rbx
str_len inp
dec rax
cmp rbx,rax
je 	zero_oprand

str_find inp,w_space
str_slicing inp,0,rax,oprand ;save oprand
str_is_equal oprand,shr_str
je not_implemented
str_is_equal oprand,shl_str
je not_implemented

str_find inp,comma
cmp rax,-1
je one_oprand_handeling

jmp two_oprand_handeling

Exit_assemble:
pop_all
ret

not_implemented:
	str_mov result_bin,not_imp_n
	str_mov result_hex,not_imp
	jmp Exit_assemble

;--------------------------------------------------------------------------------------------------
;----------------------------------------memory handeling------------------------------------------
;-------------------------------------------------------------------------------------------------- 
;				#############memory parsing################
fill_memory:
    str_find my_mem,w_space
    str_slicing my_mem,0,rax,temp
    dic_get memory_size_list,temp,mem_size ;set memory size
    
    str_find my_mem,open_ber
    inc rax
    str_slicing my_mem,rax,-1,my_mem ;QWORD PTR [r8+r12*4+0x13] -> r8+r12*4+0x13
    str_concat my_mem,plus,my_mem ; r8+r12*4+0x13+
        
    extract_memory_loop:
    	str_find my_mem,plus
    	mov rcx,rax ;save plus finded
    	str_slicing my_mem,0,rax,temp
    	str_find temp,star
    	cmp rax,-1
    	jne i_find_index_scale

    	str_find reg_code_list,temp ;check if it's register?
    	cmp rax,-1
    	je i_find_disp
    	jmp i_find_base
    		
    	i_find_index_scale:
    	mov rbx,rax ;star index
    	str_slicing temp,0,rbx,mem_index
    	inc rbx
    	str_slicing temp,rbx,0,mem_scale
    	jmp extract_memory_loop_continue
    	
    	i_find_disp:
    	str_slicing temp,2,0,mem_disp
    	jmp extract_memory_loop_continue
    	
    	i_find_base:
    	str_mov mem_base,temp
    	jmp extract_memory_loop_continue
    	
    	extract_memory_loop_continue:
    	str_len my_mem
    	inc rcx
    	cmp rcx,rax
    	jge mem_parsing_continue
    	str_slicing my_mem,rcx,0,my_mem ;r8+r12*4+0x13+ -> r12*4+0x13+
    	jmp extract_memory_loop
    	
    	
    mem_parsing_continue:
    ;check (mem_index==None and mem_base==None)
    str_is_empty mem_index
    jne mem_parsing_finish
    str_is_empty mem_base
    jne mem_parsing_finish
    
    str_mov mem_direct,num1
    
    mem_parsing_finish:
    ret
    
;				#############memory assemmbling################
set_mem:
    dic_get scale_code_list,mem_scale,mem_scale
    str_is_empty mem_disp
    je set_mod_00
    str_is_equal mem_disp,num0
    je set_mod_00
    
    get_disp_size mem_disp,MOD
    jmp set_mem_continue
    
    set_mod_00:
    str_mov MOD,num00
    jmp set_mem_continue
    
    set_mem_continue:
    str_is_empty mem_base
    je set_mem_continue2
    dic_get reg_code_list,mem_base,temp
    str_slicing temp,0,1,rex_b ;machine_code['rex']['b'] = mem.base.code[0]
    
    set_mem_continue2:
    str_is_empty mem_disp
    je set_mem_continue3
    set_disp mem_disp,MOD,disp
    
    set_mem_continue3:
    str_is_empty mem_index
    jne use_sib
    str_is_empty mem_direct
    jne use_sib
    jmp pass_sib
    
    use_sib:
    str_mov RM,num100 ;machine_code['R/M'] = '100'
    str_mov base,num101 ;machine_code['base'] = '101'
    str_mov index,num100 ;machine_code['index'] = '100'
    str_is_empty mem_scale ;machine_code['scale'] = mem.scale if mem.scale!=None else '00'
    je set_scale_00
    str_mov scale,mem_scale
    jmp use_sib_continue
    
    set_scale_00:
    str_mov scale,num00
    
    use_sib_continue:
    str_is_empty mem_base
    je use_sib_continue2
    str_slicing temp,1,0,base ;machine_code['base'] = mem.base.code[1:]
    use_sib_continue2:
    str_is_empty mem_index ;if(mem.index):
    je after_sib_handeling
    dic_get reg_code_list,mem_index,ret_str ;fetch index.code
    str_slicing ret_str,1,0,index ;machine_code['index'] = mem.index.code[1:]
    str_slicing ret_str,0,1,rex_x ;machine_code['rex']['x'] = mem.index.code[0]
    jmp after_sib_handeling
    
    pass_sib:
    dic_get reg_code_list,mem_base,temp
    str_slicing temp,1,0,RM ;machine_code['R/M'] = mem.base.code[1:]
    
    after_sib_handeling:
    ;handle prefix 67
    ;if((mem.base!=None and mem.base.mode==32) or (mem.index!=None and mem.index.mode==32))
    str_is_empty mem_base
    je second_cond_prefix67
    dic_get reg_mode_list,mem_base,temp
    str_is_equal temp,num32
    jne second_cond_prefix67
    str_mov prefix67,bnum67
    
    second_cond_prefix67:
    str_is_empty mem_index
    je handle_bp_exception
    dic_get reg_mode_list,mem_index,temp
    str_is_equal temp,num32
    jne handle_bp_exception
    str_mov prefix67,bnum67
    
    handle_bp_exception: 
    str_find mem_base,bp_str
    cmp rax,-1
    je base_empty_check
    str_is_empty mem_disp
    je handle_bp_exception_continue
    str_is_equal mem_disp,num0
    jne base_empty_check
    handle_bp_exception_continue:
    str_mov disp,num00 ;machine_code['disp']= '00000000'
    str_mov MOD,num01 ;machine_code['mod']='01' 
    
    base_empty_check:
    str_is_empty mem_base ;if(mem.base==None) exception
    je base_is_empty_exception
    ret
    
    base_is_empty_exception:
    str_mov MOD,num00
    str_slicing zero_const,0,8,temp
    str_is_equal mem_disp,num0
    je set_00000000
    str_is_empty mem_disp
    jne new_set_disp
    
    set_00000000:
    str_mov disp,temp
    ret
    
    new_set_disp:
    set_disp mem_disp,num10,disp;set_disp(mem.disp,'10')
    ret

;--------------------------------------------------------------------------------------------------
;---------------------------------------two oprand handeling---------------------------------------
;-------------------------------------------------------------------------------------------------- 
two_oprand_handeling:
    str_find inp,w_space
    lea rbx,[rax+1]
    str_slicing inp,0,rax,oprand
    str_find inp,comma
    mov rcx,rax
    str_slicing inp,rbx,rcx,dist
    inc rcx
    str_slicing inp,rcx,0,source
    get_type source,source_type
    get_type dist,dist_type
    
    opcode_filler:
    ;check2 = (op_comb=='mem-reg')
    str_is_equal source_type,mem_str ;since we don't have mem-mem and mem-imm
    jne opcode_filler_continue
    str_mov check2,num1
    opcode_filler_continue:
    ;if(op=='add'):return '000000'+str(int(check2))
    dic_get two_oprand_opcode_list, oprand, opcodeD
    str_concat opcodeD,check2,opcodeD
    
    str_is_equal source_type,reg_str
    je source_is_reg_currently
    
    str_is_equal dist_type,reg_str
    je it_is_mem_reg
    jmp it_is_mem_imm
    
    source_is_reg_currently:
    str_is_equal dist_type,reg_str
    je it_is_reg_reg
    
    str_is_equal dist_type,mem_str
    je it_is_mem_reg
    
    it_is_reg_imm:
    	jmp not_implemented
    	

    it_is_mem_imm:
    	jmp not_implemented
    	
    ;--------------------------------------reg to reg filler----------------------------------
    it_is_reg_reg: 
	    ;machine_code['W'] = '0' if source.mode==8 else '1'
	    dic_get reg_mode_list,source,temp
	    str_is_equal temp,num8
	    je it_is_reg_reg_continue1
	    str_mov code_w,num1
	    
	    it_is_reg_reg_continue1:
	    str_mov MOD,num11 ;machine_code['mod'] = '11'
	    dic_get reg_code_list,dist,ret_str ;fetch dist.code
	    str_slicing ret_str,0,1,rex_b ;machine_code['rex']['b']=dist.code[0]
	    str_slicing ret_str,1,0,RM ;machine_code['R/M'] = dist.code[1:]
	    
	    dic_get reg_code_list,source,ret_str ;fetch source.code
	    str_slicing ret_str,0,1,rex_r ;machine_code['rex']['r']=source.code[0]
	    str_slicing ret_str,1,0,REG ;machine_code['reg'] = source.code[1:]
	    
	    dic_get reg_mode_list,source,ret_str ;fetch source.mode
	    str_is_equal ret_str,num64
	    jne it_is_reg_reg_continue2
	    str_mov rex_w,num1 ;if(source.mode==64) machine_code['rex']['w']='1'
	    
	    it_is_reg_reg_continue2:
	    str_is_equal ret_str,num16
	    jne it_is_reg_reg_continue3
	    str_mov prefix66,bnum66 ;if(source.mode==16) machine_code['prefix'] = '01100110' #66
	    it_is_reg_reg_continue3:
	     
	    ;			###############handle reg reg exception############# 
	    str_is_equal oprand,imul_str
	    je reg_reg_exception
	    str_is_equal oprand,bsf_str
	    je reg_reg_exception
	    str_is_equal oprand,bsr_str
	    je reg_reg_exception
	    
	    jmp handle_two_opcode_exception
	    
	    reg_reg_exception:
	    
	    str_swap RM,REG ;swap(machine_code['R/M'],machine_code['reg'])
	    str_swap rex_r,rex_b ;swap(machine_code['rex']['r'],machine_code['rex']['b'])
	    
	    jmp handle_two_opcode_exception
    ;--------------------------------------mem to reg filler----------------------------------
    it_is_mem_reg:
	str_is_equal source_type,mem_str ;source is memory
        je it_is_reg_mem_set_d_one
        
        it_is_mem_reg_set_d_zero:
        str_slicing opcodeD,0,-1,opcodeD
	str_concat opcodeD,num0,opcodeD
	str_mov my_mem,dist
	str_mov my_reg,source
	jmp it_is_mem_reg_continue
	
        it_is_reg_mem_set_d_one:
        str_slicing opcodeD,0,-1,opcodeD
	str_concat opcodeD,num1,opcodeD
	str_mov my_mem,source
	str_mov my_reg,dist
	
	it_is_mem_reg_continue:
	;machine_code['W'] = '0' if my_reg.mode==8 else '1'
	dic_get reg_mode_list,source,temp
	str_is_equal temp,num8
	je it_is_mem_reg_continue2
	str_mov code_w,num1
	
	it_is_mem_reg_continue2:
	dic_get reg_code_list,my_reg,ret_str ;fetch my_reg.code
	str_slicing ret_str,0,1,rex_r ;machine_code['rex']['r']=my_reg.code[0]
	str_slicing ret_str,1,0,REG ;machine_code['reg'] = my_reg.code[1:]
	
	dic_get reg_mode_list,my_reg,ret_str ;fetch reg.mode
	str_is_equal ret_str,num64
	jne it_is_mem_reg_continue3
	str_mov rex_w,num1 ;if(source.mode==64) machine_code['rex']['w']='1'

	it_is_mem_reg_continue3:
	str_is_equal ret_str,num16
	jne it_is_mem_reg_continue4
	str_mov prefix66,bnum66 ;if(source.mode==16) machine_code['prefix'] = '01100110' #66
	
	it_is_mem_reg_continue4:
	call fill_memory
	call set_mem
	
    	jmp handle_two_opcode_exception
       
    ;			#############two oprand exception handeling################
    handle_two_opcode_exception:
	    str_is_equal oprand,bsf_str
	    je change_d_to_zero
	    str_is_equal oprand,bsr_str
	    je change_d_to_zero
	    str_is_equal oprand,test_str
	    je change_d_to_zero
	    str_is_equal oprand,xchg_str
	    je change_d_to_one

	    jmp stick_together
	    
	    change_d_to_one:
	    str_slicing opcodeD,0,-1,opcodeD
	    str_concat opcodeD,num1,opcodeD
	    jmp stick_together
	    
	    change_d_to_zero:
	    str_slicing opcodeD,0,-1,opcodeD
	    str_concat opcodeD,num0,opcodeD
	    
	    str_is_equal oprand,bsf_str
	    je change_w_to_zero
	    str_is_equal oprand,bsr_str
	    je change_w_to_one
	    jmp stick_together
	    
	    change_w_to_zero:
	    str_mov code_w,num0
	    jmp stick_together
	    change_w_to_one:
	    str_mov code_w,num1
	    jmp stick_together

;--------------------------------------------------------------------------------------------------
;---------------------------------------one oprand handeling---------------------------------------
;--------------------------------------------------------------------------------------------------  
one_oprand_handeling:
    str_find inp,w_space
    inc rax
    str_slicing inp,rax,0,source
    get_type source,source_type
	
    ;the section that is in both reg and mem
    dic_get one_oprand_op_list,oprand,opcodeD
    
    dic_get one_oprand_reg_list,oprand,REG

    ;if(op_comb=='reg')
    str_is_equal source_type,reg_str
    je one_reg_handeler
    jmp one_mem_handeler ;else(op_comb=='mem')
    ;				#############one reg handeler################
    one_reg_handeler:
    ;machine_code['mod'] = '11'
    str_mov MOD,num11 ;MOD=11
    
    ;machine_code['W'] = '0' if reg.mode==8 else '1'
    dic_get reg_mode_list,source,temp
    str_is_equal temp,num8
    je continue_one_oprand_handeling
    str_mov code_w,num1
    
    continue_one_oprand_handeling:
    ;machine_code['rex']['w'] = '1' if reg.mode==64 else '0'
    str_is_equal temp,num64
    jne continue2_one_oprand_handeling
    str_mov rex_w,num1
    
    continue2_one_oprand_handeling:
    ;if(reg.mode==16): machine_code['prefix'] = '01100110' #66
    str_is_equal temp,num16
    jne continue3_one_oprand_handeling
    str_mov prefix66,bnum66
    
    continue3_one_oprand_handeling:
    ;machine_code['R/M'] = reg.code[1:]
    dic_get reg_code_list,source,ret_str
    str_slicing ret_str,1,0,RM
    
    ;machine_code['rex']['b'] = reg.code[0]
    str_slicing ret_str,0,1,rex_b
    
    jmp stick_together
    
    ;				#############one memory handeler################
    one_mem_handeler:
    str_mov my_mem,source
    call fill_memory
    str_is_equal mem_size,num8
    je one_mem_handeler_continue
    str_mov code_w,num1
    
    one_mem_handeler_continue:
    call set_mem
    str_is_equal mem_size,num16 ;if(mem.size==16): machine_code['prefix'] += '01100110' #66
    jne one_mem_handeler_continue2
    str_mov prefix66,bnum66
    
    one_mem_handeler_continue2:
    str_is_equal mem_size,num16 ;if(mem.size==64):machine_code['rex']['w']='1'
    jne stick_together
    str_mov rex_w,num1
    
    jmp stick_together

;--------------------------------------------------------------------------------------------------
;------------------------------------------result printer------------------------------------------
;--------------------------------------------------------------------------------------------------  
;make result_bin ready!
stick_together:
    mov byte[result_bin],0
    str_concat result_bin,prefix67,result_bin
    str_concat result_bin,prefix66,result_bin
    ;handle rex
    str_concat sticked_rex,rex_w,sticked_rex
    str_concat sticked_rex,rex_r,sticked_rex
    str_concat sticked_rex,rex_x,sticked_rex
    str_concat sticked_rex,rex_b,sticked_rex
    str_slicing zero_const,0,4,temp

    str_is_equal sticked_rex,temp
    je stick_together_continue

    str_concat result_bin,rex_code,result_bin
    str_concat result_bin,sticked_rex,result_bin

    stick_together_continue:
    str_concat result_bin,opcodeD,result_bin
    str_concat result_bin,code_w,result_bin
    str_concat result_bin,MOD,result_bin
    str_concat result_bin,REG,result_bin
    str_concat result_bin,RM,result_bin

    str_concat result_bin,scale,result_bin
    str_concat result_bin,index,result_bin
    str_concat result_bin,base,result_bin
    str_is_empty disp
    je stick_continue
    hex_to_bin disp,disp
    str_concat result_bin,disp,result_bin

    stick_continue:
    str_find result_bin,two_colon
    cmp rax,-1
    je convert_res_bin_to_hex
    cmp rax,0
    je cut_first
    mov rbx,rax
    str_slicing result_bin,0,rbx,temp
    inc rbx
    str_slicing result_bin,rbx,0,ret_str
    str_concat temp,ret_str,result_bin

    jmp convert_res_bin_to_hex
    
    cut_first:
    	str_slicing result_bin,1,0,result_bin
    	jmp convert_res_bin_to_hex
    
convert_res_bin_to_hex:
    mov byte[result_hex],0
    str_len result_bin
    mov rbx,4
    div rbx
    cmp rdx,0
    je 	start_convert_hex
    
    sub rbx,rdx
    str_slicing zero_const,0,rbx,temp
    str_concat 	temp,result_bin,temp
    str_mov	result_bin,temp
    
    start_convert_hex:
    mov rcx,0
    str_len result_bin
    mov rdx,rax
    bin_to_hex_loop:
    	lea rbx,[rcx+4]
    	str_slicing result_bin,rcx,rbx,temp
    	dic_get bin_to_hex_list,temp,ret_str
    	str_concat result_hex,ret_str,result_hex
    	add rcx,4
    	cmp rcx,rdx
    	jl bin_to_hex_loop

    ;str_concat result_hex,disp,result_hex

    jmp Exit_assemble
    
;--------------------------------------------------------------------------------------------------
;---------------------------------------zero oprand handeling---------------------------------------
;--------------------------------------------------------------------------------------------------  
zero_oprand:
    dic_get zero_op_list,inp,result_bin
    jmp convert_res_bin_to_hex
