qemu-system-arm \
    -M versatilepb \
    -cpu arm1176 \
    -m 256 \
    -hda rpi-lite.img \
    -net nic \
    -net user,hostfwd=tcp::5022-:22 \
    -dtb versatile-pb.dtb \
    -kernel kernel-stretch \
    -append 'root=/dev/sda2 panic=1' \
    -no-reboot