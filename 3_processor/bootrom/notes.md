# ROM bootloader

Coding a bootrom(Assembler, 40) -- This allows code download into RAM over the serial port, and is baked into the FPGA image. Cute test programs run on this.

#### Questions
*What is a bootloader?*
Piece of code that loads/runs main app residing in RAM. Resides in ROM so it can't be modified.
Example: GRUB

High level
        Communication protocol (UART, USB, TCP/IP, CAN, RFLINK) 
Host <-------------------------------------------------------------> Embedded device (firmware to be upgraded)

Boot sequence
Hardware initialization firmware (Primary bootloader) -> 
                                                         Secondary Boot loader (GRUB) -> Kernel -> OS
                                                         Kernel -> Kernel -> OS

Bootloader vs Boot ROM?

*What is Master boot record?*
Also called boot sector. First 512 bytes of a disk reserved for primary bootloader.

*Minimum requirements for boot loader?*
512 bytes. ends with 0xaa55.
```assembly
jmp $ ; current mem addr

times 510-($-$$) db 0; set 0 to next 510 bytes. ($-$$): current addr - section start = prev code length
; ($-$$) = 3
; 3 + (510-3) = 510

db 0x55, 0xaa; define last 2 words

```
