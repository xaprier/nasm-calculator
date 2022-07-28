calculator: calculator.o toplama.o cikarma.o carpma.o bolme.o karekok.o faktoriyel.o bastir.o sayial.o
	gcc -o calculator calculator.o toplama.o cikarma.o carpma.o bolme.o karekok.o faktoriyel.o bastir.o sayial.o -no-pie
toplama.o: toplama.asm
	nasm -f elf64 -g -F dwarf toplama.asm -o toplama.o
cikarma.o: cikarma.asm
	nasm -f elf64 -g -F dwarf cikarma.asm -o cikarma.o
carpma.o: carpma.asm
	nasm -f elf64 -g -F dwarf carpma.asm -o carpma.o
bolme.o: bolme.asm
	nasm -f elf64 -g -F dwarf bolme.asm -o bolme.o
karekok.o: karekok.asm
	nasm -f elf64 -g -F dwarf karekok.asm -o karekok.o
faktoriyel.o: faktoriyel.asm
	nasm -f elf64 -g -F dwarf faktoriyel.asm -o faktoriyel.o
bastir.o: bastir.asm
	nasm -f elf64 -g -F dwarf bastir.asm -o bastir.o
sayial.o: sayial.asm
	nasm -f elf64 -g -F dwarf sayial.asm -o sayial.o
calculator.o: calculator.asm
	nasm -f elf64 -g -F dwarf calculator.asm -o calculator.o
