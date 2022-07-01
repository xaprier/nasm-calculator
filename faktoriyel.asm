; faktoriyel.asm
extern printf
section .data
    sayi1       dq      1.0
    bastir      db      "-> !%f = %f", 10, 0
section .bss
    sayi2       resq    1
    sonuc       resq    1
section .text
    global faktoriyel
    
faktoriyel:
    
        push rbp
        mov rbp, rsp
        
        ; sayımızın tam kısmını alıp geri xmm0 yazmacına atacaktır
        ; karekök işleminden sonra virgüllü sayı çıkıp da faktöriyel almak için gerekli
        roundsd xmm0,xmm0, 0b1100       ; round the decimal point to integer in exact value      
        
        movsd [sonuc], xmm0
    
        movsd xmm1, xmm0
        movsd xmm0, qword[sayi1]
        jmp hesapla
        
        movsd xmm0, xmm2
    
        mov rsp, rbp
        pop rbp
        ret
    
    hesapla:
        ucomisd xmm1, [sayi1]
        jle son
        mulsd xmm0, xmm1
        subsd xmm1, [sayi1]
        jmp hesapla

    son:
        movsd xmm1, xmm0
        movsd xmm0, [sonuc]
        movsd [sonuc], xmm1
        
        mov rax, 2
        mov rdi, bastir
        call printf
        
        movsd xmm0, [sonuc]
        leave
        ret
