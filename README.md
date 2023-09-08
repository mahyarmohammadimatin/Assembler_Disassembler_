<img src="https://github.com/mahyarmohammadimatin/Assembler_Disassembler_/blob/main/assembly.PNG">
In my Assembly course project, I implemented both an Assembler and a Disassembler in both Python and Assembly language.
This project aimed to explore the intricate process of converting assembly instructions into machine code and vice versa, providing valuable insights into the inner workings of computer systems and programming languages.

I developed a program that could take in assembly instructions as input and meticulously convert them into their corresponding machine code representation(vice versa in disassembeler). This involved parsing and analyzing the assembly instructions, mapping them to their respective opcodes, and generating the appropriate machine code sequences.

## Supported Arguments
Arguments can be:

- First Operand: Register (8/16/32/64 bits)
- Second Operand: Register (8/16/32/64 bits)
- First Operand: Register (8/16/32/64 bits), Second Operand: Memory (32/64 bits - direct/indirect)
- First Operand: Memory (32/64 bits - direct/indirect), Second Operand: Register (8/16/32/64 bits)
- First Operand: Register (8/16/32/64 bits), Second Operand: Immediate Data
- First Operand: Memory (32/64 bits - direct/indirect), Second Operand: Immediate Data

## Input Rules
1. A space must separate the instruction and the first operand (if present).
2. If there are two operands, they are separated by a comma without spaces (e.g., `mov rax,rbx`).
3. When an operand is memory, its size must be specified, and it should be preceded by `PTR` within square brackets (e.g., `or WORD PTR [edx*8],ax`).
4. No spaces should exist between elements within memory operands (e.g., `mov edx,DWORD ptr [ebx+ecx*1+0x32345467]`).
5. If displacement exists in memory operands, it must be in hexadecimal format starting with `0x`.
6. All characters should be in lowercase English, except for `BYTE`, `WORD`, `DWORD`, `QWORD`.
7. When a memory operand includes a register index, the `scale` value must be displayed, even if it's 1.
8. The order for base, index, scale, and displacement in memory operands is `[base+index*scale+disp]`.
9. Carefully handle cases where `ebp` or `rbp` is chosen as the base register. Refer to the Defuse website for different scenarios.
10. The only exception to hex input is for `imul`, and you only need to code for single-operand `idiv`. No need to handle cases where shift counts are held in `cl`.

## Output Rules
1. The output must be in hexadecimal.
2. There should be no `0x` prefix in the output.

**Note:** Refer to the Defuse website for all test cases: [Defuse x86 Assembler](https://defuse.ca/online-x86-assembler.htm)



## Supported Commands

| Command |           |           |           |           |           |   
|---------|-----------|-----------|-----------|-----------|-----------|
| mov     |  add      | adc       |   sub     |  sbb      |    and    |
|   or    |  xor      |  dec      |    inc    |  cmp      |  test     |
|   xchg  |  xadd     |   imul    |    idiv   |   bsf     | bsr       |
|   stc   |    clc    |     std   |    cld    |   jmp     |    jcc    |
|   shr   |  shl      |   neg     |    not    |  call     |   ret     |
| syscall |    push   |  pop      |           |           |           |
