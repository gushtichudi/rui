ASM=nasm

# TODO: obtain your own toolchain
CC=./toolchain/i386-elf-7.5.0-Linux-x86_64/bin/i386-elf-gcc


all: bl

bl: boot.asm
	$(ASM) -f bin -o boot.bin boot.asm

bin2img:
	dd if=boot.bin of=rui-0.0.0-i386.img status=progress
