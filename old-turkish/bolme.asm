; bolme.asm
extern printf
extern sayial
section .data
section .bss
section .text
    global bolme

bolme:
    section .data
        bastir      db      "-> %f / %f = %f", 10, 0
        hatamsj     db      "Girdiğiniz değer sayı olmadığından program sonlandırılıyor", 10, 0
        hatauzun    equ     $-hatamsj
    section .bss
        sonuc       resq    1
    section .text
        push rbp
        mov rbp, rsp
        
        call sayial
        
        movsd xmm2, xmm0
        divsd xmm2, xmm1
        movsd [sonuc], xmm2
        
        mov rax, 3
        mov rdi, bastir
        call printf
        
        movsd xmm0, [sonuc]
        
        mov rsp, rbp
        pop rbp
        ret
hata:
    mov rax, 1
    mov rdi, 1
    mov rsi, hatamsj
    mov rdx, hatauzun
    syscall
    
    mov rax, 60
    mov rdi, 1
    leave
    ret