ASM=nasm

# TODO: obtain your own toolchain
CC=./toolchain/i386-elf-7.5.0-Linux-x86_64/bin/i386-elf-gcc

# meta
VER=0.0.0-2
ARCH=i386
RELEASE_NAME=rui-$(VER)-$(ARCH).img

kernel:
	i686-elf-gcc -c kernel/vga.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

start_os: $(RELEASE_NAME)
	qemu-system-$(ARCH) -chardev stdio,id=char0,logfile=rui-$(VER)-serial.log,signal=off -serial chardev:char0 $(RELEASE_NAME)

clean:
	rm -rf *.log
	rm -rf *.bin
	rm -rf *.img
