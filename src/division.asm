; division.asm
extern printf
extern inputNum

section .data
section .bss
section .text
	global division

division:
	section .data
		format:		db		"-> %f / %f = %f", 10, 0
	section .bss
		result:		resq	1
	section .text
		push rbp
		mov rbp, rsp

		call inputNum

		; store will be in the xmm2 for printing
		movsd xmm2, xmm0
		divsd xmm2, xmm1

		; store the result in buffer for printf
		movsd [result], xmm2

		mov rax, 3
		mov rdi, format
		call printf

		; store the result back in the xmm0
		movsd xmm0, [result]

		mov rsp, rbp
		pop rbp
		ret