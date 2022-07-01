# nasm-calculator
A calculator with input/outputs and string->decimal number converting programmed with NASM Assembly

## How to compile and run
First of all you have to install nasm and GCC(GNU Compiler Collection) for compile and run the program. This article is only for UNIX users.

For install the nasm and GCC on Ubuntu/Debian based Operating Systems
```sh
sudo apt-get -y install nasm && sudo apt-get -y install build-essential && sudo apt-get update
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
