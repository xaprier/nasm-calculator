; inputNum.asm
extern printf
extern invalidNumber

%macro takeInput 1
	mov rax, 0			; sys_read
	mov rdi, 0			; stdin
	mov rsi, %1			; address of memory
	mov rdx, numLength	; const length
	syscall
%endmacro

%macro printInfo 2
	mov rax, 1			; sys_write
	mov rdi, 1			; stdout
	mov rsi, %1			; address of memory
	mov rdx, %2			; length of memory
	syscall
%endmacro

section .data
section .bss
section .text
global inputNum
	inputNum:
	section .data
		format1:		db		"Enter a number: ", 0
		formatlength:	equ		$-format1

		decimalstring:	dq		"", 0
		integerstring:	dq		"", 0

		numLength:		equ		15
		endl:			dq		10

		numForDiv:		dq		10.0

		negMultiplication: dq	-1.0
	section .bss
		number:			resq	1

	section .text
		; Stack alignment
		push rbp
		mov rbp, rsp

		; clear the xmm1 reg
		PXOR xmm1, xmm1

		; printing the information to user
		printInfo format1, formatlength

		; input the number from user
		takeInput number

		; find the lenth of string start from to "." or "," or "\n"
		mov rsi, number
		xor rcx, rcx		; the length in rcx register
		call findLength

		; keep the length of integer part in r8
		mov r8, rcx

		; copy the integer part of the string to "integerstring"
		mov rsi, number
		mov rdi, integerstring
		rep movsb

		; convert the integerstring to number and move to xmm1 register
		mov rsi, integerstring
		xor rbx, rbx
		xor rcx, rcx
		call convertToInteger
		dec rcx

		; divide the result by 10
		mov rdx, 0 				; for remainder
		mov rcx, 10 			; divisor
		mov rax, rbx			; dividing
		div rcx					; rax / rcx
		; cvtsi2sd = Convert Doubleword Integer to Scalar Double-Precision Floating-Point Value
		cvtsi2sd xmm1, rax		; move the result to xmm1

		; if there is no decimal point? only integer?
		mov rsi, number
		mov al, byte[rsi + r8]
		cmp al, 0xa				; no decimal only integer(\n)
		je end

		; what if not?
		; mov r8 to rcx because our string will search after location of "." or ","
		; but first we have to increment r8 by one
		inc r8
		mov rcx, r8				; rsi + rcx = location of "." or ","
		mov rsi, number 		; start address of string
		call findLength			; function will search for "null" or another ". ," with starting from first ". ,"

		; copy the substring of decimal point to decimalstring from ". or ," to "null"
		lea rsi, [number + r8]	; address of ". or ,"
		lea rdi, [decimalstring]; target address
		sub rcx, r8				; length of decimal
		mov r8, rcx				; keep the length of decimal in r8 register
		rep movsb				; copy to decimalstring the string from address of ". or ," to the end of string

		; convert the decimalstring to number and add with xmm1 register
		xor rcx, rcx			; for location
		xor rdx, rdx			; for divide
		xor rax, rax			; for taking

		; clear the xmm2 register and convert decimalstring to decimal number
		pxor xmm2, xmm2
		mov rsi, decimalstring
		call convertDecimal
		; subtract invalid character number from rcx
		sub rcx, rdx

		; 5481.41845 will return like 418450
		; we'll divide it by 10^rcx
	dividing:
		; inputNum return in xmm1
		vdivsd xmm2, [numForDiv]
		loop dividing

		; adding integer number and decimal number and returning in xmm1 register
		vaddpd xmm1, xmm2
		
	end:
		mov rsi, number
		mov al, byte[rsi]
		cmp al, 0x2d
		je negativeNumber
	continue:

		; load the string memory with null terminator 
		mov rax, 0
		mov rdi, integerstring
		mov rcx, 1
		rep stosq

		mov rax, 0
		mov rdi, decimalstring
		mov rcx, 1
		rep stosq

		mov rax, 0
		mov rdi, number
		mov rcx, 1
		rep stosq

		mov rsp, rbp
		pop rbp
		ret

	negativeNumber:
		vmulsd xmm1, [negMultiplication]
		jmp continue

	; keep the amount of invalid character in rdx
	convertDecimalInvalidCharacter:
		inc rdx
		jmp convertDecimal

	convertDecimal:
		; algorithm:
		; 123 -> take 1 -> 0 + 1 = 1 -> 1*10 = 10
		; 	  -> take 2 -> 10 + 2 = 12 -> 12*10 = 120
		; 	  -> take 3 -> 120 + 3 = 123 -> 123*10 = 1230
		; then we will divide it by 10^(rcx)
		mov al, byte[rsi + rcx]		; take first number after ". ," and so on
		inc rcx						; for address
		cmp al, 0x0 				; is it null?
		je finish					; finish the loop
		; if the character less than 0's ascii and more than 9's asii value(invalid characters)
		cmp al, 0x30
		jl convertDecimalInvalidCharacter
		cmp al, 0x39
		jg convertDecimalInvalidCharacter
		sub rax, 0x30				; convert ascii value to number
		cvtsi2sd xmm3, rax			; convert and move the value of rax to xmm3
		vaddpd xmm2, xmm3			; add the value of xmm3 to xmm2
		vmulsd xmm2, [numForDiv]	; num the value of xmm2 with by 10
		jmp convertDecimal

	convertToInteger:
		; algorithm:
		; 123 -> take 1 -> 0 + 1 = 1 -> 1*10 = 10
		; 	  -> take 2 -> 10 + 2 = 12 -> 12*10 = 120
		; 	  -> take 3 -> 120 + 3 = 123 -> 123*10 = 1230
		; then we will divide it by 10
		mov al, byte[rsi + rcx]
		inc rcx
		cmp al, 0x0				; is it null
		je finish				; finish the loop
		; if the character less than 0's ascii and more than 9's asii value(invalid characters)
		cmp al, 0x30
		jl convertToInteger
		cmp al, 0x39
		jg convertToInteger
		sub rax, 0x30			; -48 from the value of ascii(gives the integer value)
		add rbx, rax			; result in rbx
		imul rbx, 10			; multiplication with 10
		jmp convertToInteger

	findLength:
		mov al, byte[rsi + rcx]	; take 1 byte to ax register
		cmp al, 0x2e			; is it "."
		je finish				; finish the loop
		cmp al, 0x2c			; is it ","
		je finish				; finish the loop
		cmp al, 0xa				; is it "\n"
		je finish				; finish the loop
		inc rcx
		call findLength

	finish:
		ret