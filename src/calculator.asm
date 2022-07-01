; calculator.asm
extern printf
extern toplama
extern cikarma
extern carpma
extern bolme
extern karekok
extern faktoriyel
extern bastir
extern sayial

section .data
    sayialfrmt  db      "Tam Sayı giriniz: ", 0
    frmtuzun    equ     $-sayialfrmt
    
    hatamsj     db      "Girdiğiniz değer sayı olmadığından program sonlandırılıyor", 10, 0
    hatauzun    equ     $-hatamsj
    
    secimhata   db      "Geçersiz seçim! Program sonlandırılıyor...", 10, 0
    secimhatauz equ     $-secimhata
    
    msjciksec   db      "Program sonlandırılıyor...", 10, 0
    uzmsjcik    equ     $-msjciksec
    
    sayiuzun    equ     14

section .bss
    sayi1       resq      1
    secim       resq      1
    gecici      resq      1
section .text
    global main

main:
    push rbp
    mov rbp, rsp
    
    call sayial
    movsd xmm4, xmm1
    

    call bastir
    
    ; islem input alma
    mov rsi, secim
    call inputal
    
    ; islem secme
    mov rsi, secim
    xor rcx, rcx
    xor rax, rax
    xor rbx, rbx
    movsd xmm0, xmm4
    call islemsec
    
    mov rsi, secim
    cmp byte[rsi+0], 0x37
    jne dongu
    je devam

dongu:
    movsd [gecici], xmm0
    
    call bastir
    
    mov rsi, secim
    call inputal
    
    xor rcx, rcx
    xor rax, rax
    xor rbx, rbx
   
    movsd xmm0, [gecici]
    
    call islemsec
    
    jmp dongu
    
    leave
    ret

sayialbastir:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

inputal:
    push rbp
    mov rbp, rsp

    mov rax, 0
    mov rdi, 0
    mov rcx, 0
    mov rdx, sayiuzun
    syscall
    
    leave    
    ret

sayiyacevir:
    mov al, byte[rsi+rcx]
    cmp al, 0xA
    je sayiyacevir_2
    cmp al, 0x39            ; sayılardan fazla ascii değeri
    jg hata
    inc rcx
    sub al, 0x30
    add rbx, rax
    imul rbx, 10
    jmp sayiyacevir
    
sayiyacevir_2:
    ret
    
; diğer kısımlar halledilecek
islemsec:
    mov al, byte[rsi+rcx]
    cmp al, 0x31
    je toplama
    cmp al, 0x32
    je cikarma
    cmp al, 0x33
    je carpma
    cmp al, 0x34
    je bolme
    cmp al, 0x35
    je karekok
    cmp al, 0x36
    je faktoriyel
    cmp al, 0x37
    je devam
    jmp secimhatatag
    
secimhatatag:
    mov rax, 1
    mov rdi, 1
    mov rsi, secimhata
    mov rdx, secimhatauz
    syscall
    
    leave
    ret
    
hata:
    mov rax, 1
    mov rdi, 1
    mov rsi, hatamsj
    mov rdx, hatauzun
    syscall
    
    leave
    ret

devam:

    mov rax, 1
    mov rdi, 1
    mov rsi, msjciksec
    mov rdx, uzmsjcik
    syscall
    
    leave
    ret