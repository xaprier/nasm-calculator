; sqroot.asm
extern printf

section .data
section .bss
section .text
	global sqroot

sqroot:
	section .data
		format:		db		"-> √%f = %f", 10, 0
	section .bss
		result:		resq	1
	section .text
		push rbp
		mov rbp, rsp

		; result will gonna be xmm1(no other input)
		movsd xmm1, xmm0
		sqrtsd xmm1, xmm1

		; store the result in buffer for printf
		movsd [result], xmm1

		mov rax, 2
		mov rdi, format
		call printf

		; store the result back in the xmm0 
		movsd xmm0, [result]

		mov rsp, rbp
		pop rbp
		ret