%include "in_out.asm"
%include "string.asm"
%include "dictionary.asm"
%include "constants.asm"
%include "variables.asm"
%include "file_macros.asm"

section .text
    global _start
    
%macro get_reg_name 2 ;get reg code (rex_b+RM) or (rex_r+REG) and pass reg name
	push_all
	mov r15,%1
	mov r14,%2
	mov rbx,r15
	mov rcx,r14
	;if(code.rex.w=='1'): self.mod = 64 #64bit register
        ;elif(code.prefix66): self.mod = 16 #16bit register
        ;elif(code.w=='0'): self.mod = 8 #8bit register
        ;else: self.mod = 32 #32bit register
	str_is_equal rex_w,num1
	je %%set64
	str_is_equal prefix66_f,num1
	je %%set16
	str_is_equal code_w,num0
	je %%set8
	jmp %%set32
	
	%%set64:
	dic_get reg64_list,rbx,rcx
	jmp %%reg_name_continue
	%%set32:
	dic_get reg32_list,rbx,rcx
	jmp %%reg_name_continue
	%%set16:
	dic_get reg16_list,rbx,rcx
	jmp %%reg_name_continue
	%%set8:
	dic_get reg8_list,rbx,rcx
	jmp %%reg_name_continue
	
	%%reg_name_continue:
	pop_all
%endmacro
    

_start:    
    call init
    
    push path
    call readString
    
    openFile path
    mov [main_file_desc],rax
    
    get_folder_path path,folder_path
    
    str_concat folder_path,hex_file_str,hex_file_path
    
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
    	
    	
    	call disAssmble
    	
    	
    	call write_to_file
    	
    	call init
    	
    	
    	str_find buffer,new_line_char
    	mov rbx,rax
    	str_slicing buffer,rbx,0,buffer
    	str_is_equal buffer,new_line_char ;if buffer read ends
        je close_files
        str_slicing buffer,1,0,buffer
        jmp line_by_line_loop
    
    
    close_files:
        closeFile [main_file_desc]
        closeFile [hex_file_desc]
	
Exit:
    mov rax, 1
    mov rbx, 0 
    int 0x80
    
write_to_file:
    	str_concat result,new_line_char,result
    	writeFile [hex_file_desc],result
    	ret
    
disAssmble:
    str_find zero_op_list,inp
    cmp rax,-1
    jne zero_op_handeling
    
    call fill_prefix_to_RM
    
    ;operation analyse
    call operation_handeler

    
    str_is_equal MOD,num11
    jne have_mem
    str_is_equal op_count,num2
    jne one_reg_handeler
    jmp two_reg_handeler
    
    two_reg_handeler:
    str_concat rex_b,RM,temp
    get_reg_name temp,oprand1
    str_concat rex_r,REG,temp
    get_reg_name temp,oprand2
    ;if((self.d=='1' and self.operation.name!='xchg') or bsf_bsr):
    ;self.oprand1,self.oprand2=self.oprand2,self.oprand1
    str_is_equal bsf_str,operation
    je swap_oprand
    str_is_equal bsr_str,operation
    je swap_oprand
    str_is_equal code_d,num1
    jne print_res
    str_is_equal operation,xchg_str
    je print_res
    
    
    swap_oprand:
    str_swap oprand1,oprand2
    jmp print_res

    one_reg_handeler:
    str_concat rex_b,RM,temp
    get_reg_name temp,oprand1
    jmp print_res
    have_mem:
    Exit_disAssm:
    ret
    
print_res:
	str_concat operation,w_space,temp
	str_concat temp,oprand1,temp
	str_is_empty oprand2
	je print_finally
	str_concat temp,comma,temp
	str_concat temp,oprand2,temp
	
	print_finally:
	str_mov	result,temp
	jmp Exit_disAssm
    

    
operation_handeler:
	str_concat opcode,REG,temp
	str_find one_oprand_opreg_list,temp
	cmp rax,-1
	jne it_is_one_oprand
	jmp it_is_two_oprand
	


	it_is_one_oprand:
		str_mov op_count,num1
		dic_get one_oprand_opreg_list,temp,operation
		ret

	it_is_two_oprand:
		str_mov op_count,num2
		dic_get two_oprand_opcode_list,opcode,operation
		;test and exchange handeling
		str_is_equal operation,test_str
		jne bsf_bsr_handeling
		str_is_equal code_d,num1
		jne bsf_bsr_handeling
		str_mov operation,xchg_str
		
		bsf_bsr_handeling:
		str_is_equal operation,bsf_str
		jne it_is_two_oprand_fin
		str_is_equal code_w,num1
		jne it_is_two_oprand_fin
		str_mov operation,bsr_str
		
		it_is_two_oprand_fin:
		ret
  
fill_prefix_to_RM:
    str_find inp,num67
    cmp rax,0
    jne check_prefix66
    str_mov prefix67_f,num1
    str_slicing inp,2,0,inp
    
    check_prefix66:
    str_find inp,num66
    cmp rax,0
    jne check_rex
    str_mov prefix66_f,num1
    str_slicing inp,2,0,inp
    
    check_rex:
    str_find inp,num4
    cmp rax,0
    jne check_opcode
    str_slicing inp,1,2,temp ;one hex digit representing 4bits of rex
    dic_get hex_to_bin_list,temp,temp
    str_slicing temp,0,1,rex_w
    str_slicing temp,1,2,rex_r
    str_slicing temp,2,3,rex_x
    str_slicing temp,3,4,rex_b
    str_slicing inp,2,0,inp
    
    check_opcode:
    str_find inp,num0f
    cmp rax,0
    jne check_mov_exception
    str_slicing inp,0,4,temp
    hex_to_bin temp,opcode
    str_slicing inp,4,0,inp
    jmp end_opcode
    
    check_mov_exception: ;pass for nowwwwwwwwwwwwwwwwwwwwww
    str_find inp,numb
    cmp rax,0
    jne check_opcode8
    jmp end_opcode
    
    check_opcode8:
    str_slicing inp,0,2,temp
    hex_to_bin temp,opcode
    str_slicing inp,2,0,inp
    
    end_opcode:
    str_len opcode
    mov rcx,rax
    mov rbx,rax
    dec rbx
    str_slicing opcode,rbx,rcx,code_w
    dec rcx
    dec rbx
    str_slicing opcode,rbx,rcx,code_d
    str_slicing opcode,0,-2,opcode
    
    ;set mod, reg, R/M   
    str_slicing inp,0,2,temp
    hex_to_bin temp,temp ;bin_sec = hex_bin(inp[:2])
    ;self.mod,self.reg,self.r_m = bin_sec[:2],bin_sec[2:5],bin_sec[5:8]
    str_slicing temp,0,2,MOD
    str_slicing temp,2,5,REG
    str_slicing temp,5,8,RM
    str_slicing inp,2,0,inp
    
    ret
  
zero_op_handeling:
	dic_get zero_op_list,inp,temp
	str_mov result,temp
	jmp Exit
	
init:
	str_mov prefix66_f,num0
	str_mov prefix67_f,num0
	str_mov rex_w,num0
	str_mov rex_r,num0
	str_mov rex_x,num0
	str_mov rex_b,num0
	mov byte[opcode],0
	mov byte[code_w],0
	mov byte[code_d],0
	mov byte[MOD],0
	mov byte[REG],0
	mov byte[RM],0
	mov byte[operation],0
	mov byte[op_count],0
	mov byte[oprand1],0
	mov byte[oprand2],0
	;mov byte[result],0
ret

