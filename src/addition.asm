; addition.asm
extern printf
extern inputNum

section .data
section .bss
section .text
	global addition

addition:
	section .data
		format:		db		"-> %f + %f = %f", 10, 0
	section .bss
		result:		resq	1
	section .text

		push rbp
		mov rbp, rsp

		; input decimal number and store in xmm2(result)
		call inputNum
		movsd xmm2, xmm1
		; add the number with before one
		addsd xmm2, xmm0

		; store the result in local memory
		movsd [result], xmm2

		; print the result
		mov rax, 3
		mov rdi, format
		call printf

		; get back the result value to xmm0
		movsd xmm0, [result]

		mov rsp, rbp
		pop rbp
		ret