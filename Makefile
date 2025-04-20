# TODO: obtain your own toolchain
CC=./toolchain/i386-elf-7.5.0-Linux-x86_64/bin/i386-elf-gcc
ASM=./toolchain/i386-elf-7.5.0-Linux-x86_64/bin/i386-elf-as

# meta
VER=0.0.0-5
ARCH=i386
RELEASE_NAME=rui-$(VER)-$(ARCH)

.PHONY: kernel clean start_os

kernel:
	$(ASM) boot.asm -o boot.o
	$(CC) -c kernel/rui.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	$(CC) -T link.ld -o rui.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

bin2iso: rui.bin
	mkdir -p isodir/boot/grub
	cp rui.bin isodir/boot/rui.bin
	cp res/grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o $(RELEASE_NAME).iso isodir

start_os: $(RELEASE_NAME).iso
	qemu-system-$(ARCH) -chardev stdio,id=char0,logfile=rui-$(VER)-serial.log,signal=off -serial chardev:char0 $(RELEASE_NAME).iso

clean:
	rm -rf *.o
	rm -rf *.log
	rm -rf *.bin
	rm -rf *.img
