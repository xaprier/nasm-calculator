; calculator.asm
extern printf
extern selectionPrinting
extern inputNum
extern addition
extern subtraction
extern multiplication
extern division
extern sqroot
extern factorial


%macro takeInput 1
	mov rax, 0 				; sysread
	mov rdi, 0 				; stdin
	mov rsi, %1 			; address of memory
	mov rdx, numLength
	syscall
%endmacro
section .data
	inputNumFormat:			db		"Enter a number: ", 0
	iNLength:				equ		$-inputNumFormat

	err1:					db		"You entered invalid number... Exiting from program!", 10, 0
	err1Length:				equ		$-err1

	invalidSelect:			db		"Invalid select! Exiting from program...", 10, 0
	iSLength:				equ		$-invalidSelect

	formatExit:				db		"Exiting from program...", 10, 0
	fELength:				equ		$-formatExit

	numLength:				equ		15

section .bss
	num1:					resq	1
	selection:				resq	1

section .text
	global main
	global invalidNumber

main:
	; stack alignment
	push rbp
	mov rbp, rsp

	; the number coming in xmm1
	call inputNum
	movsd xmm0, xmm1


loopForSelect:
	movsd [num1], xmm0

	; print to console for selection menu
	call selectionPrinting

	; input the select
	takeInput selection

	; select operation
	mov rsi, selection
	xor rcx, rcx
	xor rax, rax
	xor rbx, rbx
	movsd xmm0, [num1]			; number in xmm0 register
	call selOperation
	jmp loopForSelect

	leave
	ret

selOperation:
	mov al, byte[rsi + rcx]
	cmp al, 0x31				; is it 1
	je addition

	cmp al, 0x32 				; is it 2
	je subtraction

	cmp al, 0x33 				; is it 3
	je multiplication

	cmp al, 0x34				; is it 4
	je division

	cmp al, 0x35				; is it 5
	je sqroot

	cmp al, 0x36				; is it 6
	je factorial

	cmp al, 0x37				; is it 7(exit)
	je exiting

; if user selected none of above 
invalidSelection:
	mov rax, 1
	mov rdi, 1
	mov rsi, invalidSelect
	mov rdx, iSLength
	syscall
	leave
	ret
invalidNumber:
	mov rax, 1
	mov rdi, 1
	mov rsi, err1
	mov rdx, err1Length
	syscall
	leave
	ret
exiting:
	mov rax, 1
	mov rdi, 1
	mov rsi, formatExit
	mov rdx, fELength
	syscall
	leave
	ret
