; multiplication.asm
extern printf
extern inputNum

section .data
section .bss
section .text
	global multiplication

multiplication: 
	section .data
		format:		db		"-> %f x %f = %f", 10, 0

	section .bss
		result:		resq	1

	section .text
		push rbp
		mov rbp, rsp

		call inputNum
		; the result is gonna be xmm2
		movsd xmm2, xmm0
		mulsd xmm2, xmm1

		; store the result in buffer for printf
		movsd [result], xmm2

		mov rax, 3
		mov rdi, format
		call printf

		; store back in the xmm0 the result
		movsd xmm0, [result]

		mov rsp, rbp
		pop rbp
		ret