# nasm-calculator
A calculator with input/outputs and string->decimal number converting programmed with NASM Assembly

### Recording code sessions and uploaded to YouTube playlist 
<a href="https://youtube.com/playlist?list=PLUWaeJl-QWIK_1kxDXxHd1BN9Av0LzF9C" target="_blank">Click for playlist!</a>

## How to compile and run
First of all you have to install nasm and GCC(GNU Compiler Collection) for compile and run the program. This article is only for UNIX users.

For install the nasm and GCC on Ubuntu/Debian based Operating Systems
```sh
sudo apt-get -y install nasm build-essentials && sudo apt-get update -y 
```

For install the nasm and GCC on Arch based using pacman Operating Systems(gdb optional for debugging*)
```sh
sudo pacman -Syu nasm base-devel gdb make
```

Clone the repository using git. If you don't have git then you have to install it.
```sh
git clone git@github.com:xaprier/nasm-calculator.git
```

Enter the directory of the source files and makefile
```sh
cd src/
```

We have a easy makefile for compile the program, we will run it.
```sh
make
```

Then our program is ready with the name "calculator". You can run the program with this command
```sh
./calculator
```