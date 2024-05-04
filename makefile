
SRC_DIR := ./src
OBJ_DIR := ./obj
SRC_FILES := $(wildcard $(SRC_DIR)/*.asm)
OBJ_FILES := $(patsubst $(SRC_DIR)/%.asm,$(OBJ_DIR)/%.o,$(SRC_FILES))

CREATE_DIR := $(shell mkdir -p obj)

calculator: $(OBJ_FILES)
	gcc $^ -o $@ -no-pie

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm
	nasm -f elf64 -g -F dwarf $< -o $@ 