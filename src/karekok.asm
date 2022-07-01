; karekok.asm
extern printf
section .data
section .bss
section .text
    global karekok

karekok:
    section .data
        bastir      db      "-> √%f = %f", 10, 0
    section .bss
        sonuc       resq    1
    section .text
        push rbp
        mov rbp, rsp
        
        movsd xmm1, xmm0
        sqrtsd xmm1, xmm0
        movsd [sonuc], xmm1
        
        
        mov rax, 2
        mov rdi, bastir
        call printf
        
        movsd xmm0, [sonuc]
    
        mov rsp, rbp
        pop rbp
        ret