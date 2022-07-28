; selectionPrinting.asm
extern printf
section .data
section .bss
section .text
	global selectionPrinting

selectionPrinting:
	section .data
		format1:	db		"%s%s%s%s", 10, 0
		addsel:		db		10, " 1 - Addition", 10, 0
		subsel:		db		" 2 - Subtraction", 10, 0
		mulsel:		db		" 3 - Multiplication", 10, 0
		divsel:		db		" 4 - Division", 0
		srsel:		db		" 5 - Square Root", 10, 0
		facsel:		db		" 6 - Factorial", 10, 0
		exsel:		db		" 7 - Exit", 10, 0
		selection:	db		10, "Select one of these given above: ", 0

	section .text
		push rbp
		mov rbp, rsp

		mov rax, 0
		mov rdi, format1
		mov rsi, addsel
		mov rdx, subsel
		mov rcx, mulsel
		mov r8, divsel
		call printf

		mov rax, 0
		mov rdi, format1
		mov rsi, srsel
		mov rdx, facsel
		mov rcx, exsel
		mov r8, selection
		call printf

		mov rsp, rbp
        pop rbp
		ret