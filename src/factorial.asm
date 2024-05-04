; factorial.asm
extern printf

section .data
section .bss
section .text
	global factorial

factorial:
	section .data
		format:			db		"-> !%f = %f", 10, 0
		tempNum:		dq		1.0
	section .bss
		result:			resq	1
	section .text
		push rbp
		mov rbp, rsp

		; round the value to nearest integer value
		roundsd xmm0, xmm0, 0b0000
		; store the value of will gonna be take factorial
		movsd [result], xmm0

		movsd xmm1, xmm0
		movsd xmm0, qword[tempNum]
		jmp calc

	calc:
		; compare the value with 1.0
		ucomisd xmm1, [tempNum]
		; jump if less or equal to endLoop
		jle endLoop
		; multiplicate the value and store in xmm0
		mulsd xmm0, xmm1
		; subtract by one the number
		subsd xmm1, [tempNum]
		; loop with jump
		jmp calc
	endLoop:
		; store the result in xmm1
		movsd xmm1, xmm0
		; store the coming number back in the xmm0
		movsd xmm0, [result]
		; store the result back in the buffer for printf
		movsd [result], xmm1

		mov rax, 2
		mov rdi, format
		call printf

		; store the result back in the xmm0
		movsd xmm0, [result]

		mov rsp, rbp
		pop rbp
		ret