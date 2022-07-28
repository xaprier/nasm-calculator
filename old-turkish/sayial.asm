extern printf

%macro inputal 1
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, sayiuzun
    syscall
%endmacro

%macro yazdir 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
    
    mov rax, 1
    mov rdi, 1
    mov rsi, YNS
    mov rdx, 1
    syscall
%endmacro

section .data
    sayialformat:   db  "Sayı giriniz: ", 0
    sayialformatuz: equ  $-sayialformat

    virgulkatar:    dq  "", 0
    tamkatar:       dq  "", 0

    gecici:         dq  "", 0

    sayiuzun:       equ 15
    YNS             dq 10
    boluneceksayi:  dq  10.0

section .bss
    sayi:   resq    1


section .text
    global sayial
    
sayial:
    push rbp
    mov rbp, rsp
    PXOR xmm1, xmm1
; Sayı almak için bilgi mesajı bastırma
    yazdir sayialformat, sayialformatuz
    
; Sayıyı input almak
    inputal sayi
    
; girilen sayının başlangıçtan . veya , veya "\n" ile arasındaki uzunluğu bulma(rcx'te dönecek uzunluk) 
    mov rsi, sayi
    xor rcx, rcx
    xor rax, rax
    call uzunlukbul
; sayi alanındaki değeri rcx'teki uzunluğa göre(tam kısmın sonuna kadar) tamkatar kısmına kopyalama işlemi
    mov rsi, sayi
    mov rdi, tamkatar
    mov r8, rcx
    rep movsb
    

; r8 uzunluğunu bir arttırıyoruz(null terminator) ve tamkatar kısmını bastırıyoruz
    yazdir tamkatar, r8
    
; tamkatar kısmını sayıya çevirip xmm1 yazmacına aktarıyoruz
    mov rsi, tamkatar
    xor rbx, rbx
    xor rcx, rcx
    call tamsayicevir
    
    mov rdx, 0
    mov rcx, 10
    mov rax, rbx
    div rcx
    cvtsi2sd xmm1, rax

; sadece tam sayı girilirse?
    mov rsi, sayi
    mov al, byte[rsi+r8]
    cmp al, 0xa
    je son
    
; rcx'e r8 değerini atıyoruz çünkü katarımız . karakterinden sonra aranmaya başlanacak
    inc r8              ; .'dan sonra!
    mov rcx, r8
    mov rsi, sayi
    call uzunlukbul     ; fonksiyon . karakterinden sonra, null terminator veya başka nokta ile karşılaşıncaya kadar arayacaktır
    
; .'dan sonraki null terminator'e kadar olan kısmın uzunluğu bulundu ve rcx yazmacında
    lea rsi, [sayi+r8]      ; sayi'nin başlangıç adresi
    lea rdi, [virgulkatar]  ; hedef kaynak
    sub rcx, r8             ; tüm sayının uzunluğu - .'nın adresi(virgül kısmın uzunluğu döner)
    mov r8, rcx             ; r8'de virgül kısmın uzunluğunu yedek diye tutuyoruz
    rep movsb               ; ve hedef kaynağa, alınan kaynaktan kopyalama işlemi yapıyoruz

    yazdir virgulkatar, r8
    
; virgulkatar kısmını sayıya çevirip xmm1 yazmacındaki değerle topluyoruz!
    xor rcx, rcx    ; konum için
    xor rdx, rdx    ; bölüm için

    pxor xmm2, xmm2
    mov rsi, virgulkatar
    call virgulsayicevir

    cmp rcx, 0
    jg bolsene

bolsene:
    ; alınan sayı xmm1 yazmacında dönüyor
    vdivsd xmm2, [boluneceksayi]
    loop bolsene
    vaddpd xmm1, xmm2

    mov rax, 0
    mov rdi, tamkatar
    mov rcx, sayiuzun
    rep stosb

    mov rax, 0
    mov rdi, virgulkatar
    mov rcx, sayiuzun
    rep stosb

son:
    mov rsp, rbp
    pop rbp
    ret
    
; Fonksiyonlar
uzunlukbul:
    mov al, byte[rsi+rcx]
    cmp al, 0x2e
    je bitir
    cmp al, 0x2c
    je bitir
    cmp al, 0xa
    je bitir
    inc rcx
    call uzunlukbul
    ret

tamsayicevir:
    mov al, byte[rsi+rcx]
    cmp al, 0x0
    je bitir
    inc rcx
    sub rax, 0x30
    add rbx, rax
    imul rbx, 10
    jmp tamsayicevir
    ret
virgulsayicevir:
    mov al, byte[rsi + rcx]
    inc rcx         ; alınan adres için
    cmp al, 0x0
    je bitir
    sub rax, 0x30   ; ascii değeri sayıya çevir
    cvtsi2sd xmm3, rax
    vaddpd xmm2, xmm3
    vmulsd xmm2, [boluneceksayi]
    jmp virgulsayicevir
    ret
bitir:
    ret
