; bastir.asm
extern printf
section .data
section .bss
section .text
    global bastir
    
bastir:
    section .data
        frmt        db  10, "%s %s %s %s", 10, 0
        frmt2       db  "%s %s %s", 10, 0
        
        topsec      db  " 1 - Toplama", 10, 0
        cikarsec    db  "2 - Çıkarma", 10, 0
        carpsec     db  "3 - Çarpma", 10, 0
        bolsec      db  "4 - Bölme", 0
        karesec     db  " 5 - Karekök", 10, 0
        faksec      db  "6 - Faktöriyel", 10, 0
        ciksec      db  "7 - Çıkış", 10, 0
        islemsec    db  "Yukardaki işlemlerden birisini seçiniz: ", 0
        otouzun     equ $-islemsec
    section .text
        push rbp
        mov rbp, rsp
        
        mov rax, 0
        mov rdi, frmt
        mov rsi, topsec
        mov rdx, cikarsec
        mov rcx, carpsec
        mov r8, bolsec
        call printf
        
        mov rax, 0
        mov rdi, frmt2
        mov rsi, karesec
        mov rdx, faksec
        mov rcx, ciksec
        call printf
        
        mov rax, 1
        mov rdi, 1
        mov rsi, islemsec
        mov rdx, otouzun
        syscall
        
        mov rsp, rbp
        pop rbp
        ret