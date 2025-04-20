cd res/
mkdir -p isodir/boot/grub
cp rui.bin isodir/boot/rui.bin
cp grub.cfg isodir/boot/grub/grub.cfg
grub-mkrescue -o $1.iso isodir
