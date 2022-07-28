; subtraction.asm
extern printf
extern inputNum

section .data
section .bss
section .text
	global subtraction

subtraction:
	section .data
		format:		db		"-> %f - %f = %f", 10, 0
	section .bss
		result:		resq		1
	section .text
		push rbp
		mov rbp, rsp

		call inputNum

		; move the value of last result to xmm2(result)
		movsd xmm2, xmm0
		; result will gonna be xmm2
		subsd xmm2, xmm1

		; store the result in buffer for printf
		movsd [result], xmm2

		mov rax, 3
		mov rdi, format
		call printf

		; store back the result in xmm0
		movsd xmm0, [result]

		mov rsp, rbp
		pop rbp
		ret