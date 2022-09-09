# From the Transistor to the Web Browser

Hiring is hard, a lot of modern CS education is really bad, and it's hard to find people who understand the modern computer stack from first principles.

Now cleaned up and going to be software only. Closer to being real.

## Section 1: Intro: Cheating our way past the transistor -- 0.5 weeks
- So about those transistors -- Course overview. Describe how FPGAs are buildable using transistors, and that ICs are just collections of transistors in a nice reliable package. Understand the LUTs and stuff. Talk briefly about the theory of transistors, but all projects must build on each other so we can’t build one.
- Emulation -- Building on real hardware limits the reach of this course. Using something like Verilator will allow anyone with a computer to play.

## Section 2: Bringup: What language is hardware coded in? -- 0.5 weeks
- Blinking an LED(Verilog, 10) -- Your first little program! Getting the simulator working. Learning Verilog.
- Building a UART(Verilog, 100) -- An intro chapter to Verilog, copy a real UART, introducing the concept of MMIO, though the serial port may be semihosting. Serial test echo program and led control.

## Section 3: Processor: What is a processor anyway? -- 3 weeks
- Coding an assembler(Python, 500) -- Straightforward and boring, write in python. Happens in parallel with the CPU building. Teaches you ARM assembly. Initially outputs just binary files, but changed when you write a linker.
- Building a ARM7 CPU(Verilog, 1500) -- Break this into subchapters. A simple pipeline to start, decode, fetch, execute. How much BRAM do we have? We need at least 1MB, DDR would be hard I think, maybe an SRAM. Simulatable and synthesizable.
- Coding a bootrom(Assembler, 40) -- This allows code download into RAM over the serial port, and is baked into the FPGA image. Cute test programs run on this.

## Section 4: Compiler: A “high” level language -- 3 weeks
- Building a C compiler(Haskell, 2000) -- A bit more interesting, cover the basics of compiler design. Write in haskell. Write a parser. Break this into subchapters. Outputs ARM assembly.
    - Learning Haskell
        - Learn functional programming
        - A basic haskell guide
        - build an API. chat? 
    - Learning C
    - Learning Compiler theory
        - Basics 
        - C -> ARM
    - Build C -> ARM compiler
- Building a linker(Python, 300) -- If you are clever, this should take a day. Output elf files. Use for testing with QEMU, semihosting.
- libc + malloc(C, 500) -- The gateway to more complicated programs. libc is only half here, things like memcpy and memset and printf, but no syscall wrappers.
- Building an ethernet controller(Verilog, 200) -- Talk to a real PHY, consider carefully MMIO design.
- Writing a bootloader(C, 300) -- Write ethernet program to boot kernel over UDP. First thing written in C. Maybe don’t redownload over serial each time and embed in FPGA image.

## Section 5: Operating System: Software we take for granted -- 3 weeks
- Building an MMU(Verilog, 1000) -- ARM9ish, explain TLBs and other fun things. Maybe also a memory controller, depending on how the FPGA is, then add the init code to your bootloader.
- Building an operating system(C, 2500) -- UNIXish, only user space threads. (open, read, write, close), (fork, execve, wait, sleep, exit), (mmap, munmap, mprotect). Consider the debug interface you are using, ranging from printf to perhaps a gdbremote stub into kernel. Break into subchapters.
- Talking to an SD card(Verilog, 150) -- The last hardware you have to do. And a driver
- FAT(C, 300) -- A real filesystem, I think fat is the simplest
- init, shell, download, cat, ls, rm(C, 250) -- Your first user space programs.

## Section 6: Browser: Coming online -- 1 week
- Building a TCP stack(C, 500) -- Probably coded in the kernel, integrate the ethernet driver into the kernel. Add support for networking syscalls to kernel. (send, recv, bind, connect)
- telnetd, the power of being multiprocess(C, 50) --  Written in C, user can connect multiple times with telnet. Really just a bind shell.
- Space saving dynamic linking(C, 300) -- Because we can, explain how dynamic linker is just a user space program. Changes to linker required.
- So about that web(C, 500+) -- A “nice” text based web browser, using ANSI and terminal niceness. Dynamically linked and nice, nice as you want.

## Section 7: Physical: Running on real hardware -- 1 week
- Talking to an FPGA(C, 200) -- A little code for the USB MCU to bitbang JTAG.
- Building an FPGA board -- Board design, FPGA BGA reflow, FPGA flash, a 50mhz clock, a USB JTAG port and flasher(no special hardware, a little cypress usb mcu to do jtag), a few leds, a reset button, a serial port(USB-FTDI) also powering via USB, an sd card, expansion connector(ide cable?), and an ethernet port. Optional, expansion board, host USB port, NTSC TV out, an ISA port, and PS/2 connector on the board to taunt you. We provide a toaster oven and a multimeter thermometer to do reflow. 
- Bringup -- Compiling and downloading the Verilog for the board
---
# Section 1: Intro: Cheating our way past the transistor -- 0.5 weeks
# So About those transistors
> So about those transistors -- Course overview. Describe how FPGAs are buildable using transistors, and that ICs are just collections of transistors in a nice reliable package. Understand the LUTs and stuff. Talk briefly about the theory of transistors, but all projects must build on each other so we can’t build one.
## History
Before the transistor  
**Vaccum tubes**  
Use heat turn circuits on or off

## Transistor components
**Transistors** 
- the "atoms" of integrated circuits
- used as *switches* or amplifiers to electrical currents
- made out of p-n (positive-negative) junctions - the border between p-doped and n-doped silicon.
- Uses atomic elements (phosphorus and boron) to turn on or off

**Electricity**  
The motion of electrons through charged semiconductant materials

**Silicon**  
Semiconductor with 4 electrons on its outer energy level; is able to form a stable crystal lattice made of four-way covalent bonds when not altered

**Diodes**  
Allows current to flow in one direction if a certain voltage is reached. Consists of an *anode*, *cathode*, and depletion layer between them.
- **Anode** - P-doped (positive) side of junction
- **Cathode** - N-doped (negative) side of junction 
- **Depletion layer** - Emerges where the excess electrons from the cathode and holes from the anode meet, creating a *layer depleted of charge*; can be altered in size 
- **Forward Bias** - when electric current can flow freely through the circut
- **Reverse Bias** - when electric current is prevented from flowing through the diode, making an *insulator* out of the diode

**Doping Silicon - Introducing Charge**
- **Phosphorus -> Negative charge**
  - Replacing silicon atoms with *phosphorous* atoms in a matrix of silicon atoms introduces a negative charge since *extra electrons* are bouncing through the group of silicon atoms
- **Boron -> Positive charge** 
  - Replacing silicon atoms with *boron* atoms in a matrix of silicon atoms creates "holes" *(missing electrons)*, introducing a positive charge in the silicon plate

**Depletion Layer / Dead Zone** 
- emerges when excess electrons from the cathode and holes from the anode meet, creating a layer depleted of charge
- when large enough, the dead zone effectively blocks the flow of electrons crossing the p-n junction, preventing the flow of electricity  
- can be manipulated in size by applying different voltages to the p-doped and n-doped plates  

**NPN Bipolar junction transistor type transistor**  
- N: n-doped layer, P: p-doped layer; two n-p junctions
- A forward bias on one n-p junction will natrually cause a reverse bias on the other n-p junction; this leads to you needing a second voltage applied for current to flow

## Integrated Circuits
**What are Integrated Circuits?**  
Very small circuits made from other smaller circuits made out of discrete logic components made out of silicon  

**How are Integrated Circuits made?**  
1. **create Wafer** - Slice a cylinder of silicon to create a wafer  
2. **Masking** - Add protective layer called **photoresist** to all of wafer  
3. **Etching** - Remove **photoresist** from some parts of silicon  
4. **Doping** - Introduce impurities into the etched parts of silicon. This can be done by heating up the wafer, or blasting positively and negetively charged atoms onto it. This will create n-doped junctions and p-doped junctions.  

**Boolean logic** - Math? Function with binary input, binary output. Ex: fn = AND(one: 0|1, two: 0|1) -> out: 0|1  
**Logic gates** Implementation of boolean logic from discrete logic units (transistors and such). Transistors can act as switches, which can be on or off. We can use boolean gates to create boolean logic (ex AND, OR, XOR).  

**FPGA - Field Programmable Gate Array**
- "programmable hardware"; you can configure digital logic that will run on actual hardware (LUTS, Switches, FlipFlops, and BRAM)
- Design digital functions by programming the hardware using an HDL like Verilog or VHDL; helpful note: not programming languages
- Composed of 10s of thousands of (or more) **CLBS** for hobbby FPBGAs; in those CLBS are many Logic Blocks, signals are routed using the Interconnected Matrix which sounds like a matrix of wires that allow signals to be routed to Logic Blocks through Switches (latches?); inputs and outputs can be "programmed" or configured in the LUT acting like a Truth Table that simulates practically any function with the same number of inputs and outputs; signals can be then routed anywhere within the FPGA

**CLB - Configurable Logic Block**
- More complex than Gates because they can implement any digital function, have flexible inputs  
- Can be programmed with HDL or Verilog  
- Contain a few *logic cells*  

**Logic cell**
Contains *Flip flops*, a *full-adder* and *LUTs*  

**Full-adder**
Takes in two binary inputs, each one bit, and a carry input, outputs the sum of the binary inputs, and the carry bit.  

**LUTs - Lookup tables**
Implentation of Boolean Gates (AND|OR|...) using muxes that act as truth tables. We hardcode the output for specific inputs.  

**Register/Flip flop**
Record the value of input every clock cycle. Used to "record" state.  

**Microcontroller**
- CPU
- memory (in memory cells within a IC chip)
- programmable I/O
- sometimes a little RAM
- insignificant power consumption when off

## Reference Links
Transistor Theory - https://backyardbrains.com/experiments/transistorTheory#prettyPhoto  
Transistor Circuit Design - https://backyardbrains.com/experiments/transistorDesign
  
# Emulation
> Emulation -- Building on real hardware limits the reach of this course. Using something like Verilator will allow anyone with a computer to play.

---
# Section 2: Bringup: What language is hardware coded in? -- 0.5 weeks

# Blinking LED
> Blinking an LED(Verilog, 10) -- Your first little program! Getting the simulator working. Learning Verilog.

Look at implementation
# Building a UART
> Building a UART(Verilog, 100) -- An intro chapter to Verilog, copy a real UART, introducing the concept of MMIO, though the serial port may be semihosting. Serial test echo program and led control.

Look at implementation

---
# Section 3: Processor: What is a processor anyway? -- 3 weeks
# Coding an assembler
> Coding an assembler(Python, 500) -- Straightforward and boring, write in python. Happens in parallel with the CPU building. Teaches you ARM assembly. Initially outputs just binary files, but changed when you write a linker.

## Stack
Stack pointer: points to top of stack.
every memory address holds a byte
```
0x01 n
0x02 s
0x03 fourth <- top of stack
0x04 third
0x05 second
0x05 first

stack grows from high address, to lower address
```

## Link register
Link register: parent function memory address
example:

with function calls:
```
a()
b()
c()
```
corresponding lrs
```
a()
lr = b

b()
lr = c

c()
```

## CPSR
Current Program Status Register (CPSR): Holds state of last excecution.
Example: wether there was a carry bit, negative value, if we're in privileged mode, ...

## ARM vs Thumb
ARM VS Thumb (arm state)
ARM:
- Instructions are 32-bit
- Conditional execution
- Barrel shifter: shrinks multiple instructions into one
Thumb:
- Usuually instructions are 16-bit, can be 32-bit if need be.
- Conditional execution by using `IT` instructions (only available on some archs)
- Useful for exploits, because there's less NULL bytes. Example. 8 = 0000 0000 0000 1000 in 32 bit, 0000 1000 in 16-bit.

### Notes while programming
When reading PC while debugging, PC will point to two instructions ahead. This is old behavior that is maintained to ensure compatability.
Carry occurs if result of a subtraction is >= 0

Program counter: current instruction memory address plus word length (8 in a 32-bit arch)
during branch: holds destination address

#### Questions:

What's up with arm storing first four argruments of a function in first four registers? Only four arguments can be stored at a time? Is a functino an arm instruction?

## Implementing an assembler
Assembler: assembly file -> assembler -> machine code
1. Parse each instruction into an operator, register, memory address, etc
2. Map each instruction into machine code for armv6
  - Map each operator into machine code
  - Map each register into machine code
  - Map each memory address into machine code

Example:
```
mov r0, #5 -> 0101010101....
```

### Machine languages
``` 
Binary:         10101011 10101111 000001010110010010 # Numbers depend on ARM asm spec 
                ________|________|________________
Symbolic (asm): LOAD     R3       7
```

### Symbols
Symbol = Variable | Label | pre-defined symbol (operator, mnemonic, registers)
Each symbol is mapped to a memory address specified in Symbol Table

Label: maps to next intruction memory adderss
Variable: each new variable assembler looks at gets assigned higher memory address

### Binary code file:
a 32-bit instruction in every line

Instructions:
A-instruction
B-instruction

Example:
```
01011100010111000101110001011100
01011100010111000101110001011100
```

### ELF (Executable Linux File)
Includes necessary headers, metadata, and binary program to execute. We need to turn a machine-code file into an ELF file to be able to execute it.

#### Questions
*How does the asm know which memory address a pre-defined symbol (mnemonic/register/operator) belongs to?*
The assembly spec (ARMv7 spec) speficies a number for every pre-defined symbol. These values are initiliazed when the assembler start
```
hypothetical symbol table
-----------
mov | 0x1
add | 0x2
sub | 0x3
 ...  |
```

*How does the asm know which memory address a label belongs to?*
In the first pass, the asm maps the label name, to the next instruction memory address in the Symbolic Table
Example
```
label: 0x0
  add 5, 2 0x1

symbol table
-----------
label | 0x1
 ...  |
```

*How does the asm know which memory address a variable belongs to?*
In the first pass, the asm looks for variable declarations, and maps a memory address for it in the Symbolic Table. In the second pass, asm replaces all variables with memory address in Symbolic Table.
Example
```
var1= 0
var2= 0

symbol table
-----------
var1  | 1024
var2  | 1025
 ...  |
```

### Assember pseudo-code
```
def assembler:
  bin_instructions = []

  for line in file: #line is a command (or whitespace/comment)
    fields = parse_fields(line) # 'LOAD r1, 7' -> [LOAD, r1, 7]

    command_bin_codes = []
    for field in fields:
      bin_code = field_binary_code(field) # LOAD -> 0101010110
      cmd_bin_codes.add(bin_code)
    cmd_bin_instructions = parse_bin_codes(command_bin_codes) #list of 32-bit binaries
    bin_instructions.add(cmd_bin_instructions)

  asm_bin_instructions = assemble_bin_codes(bin_instructions)
  file.write('asm.o', asm_bin_instructions)
```

Implmentation overview:
- [X] parse source code into commands
for every command
  - [X] parse commands into instruction fields ('mov r1, r0' -> 'mov', 'r0', 'r1')
  - [ ] map instruction field into binary number ('mov' -> '001010 01010 01010')
  - [ ] add instruction binary to output file
  
---
# Building a ARM7 CPU
> Building a ARM7 CPU(Verilog, 1500) -- Break this into subchapters. A simple pipeline to start, decode, fetch, execute. How much BRAM do we have? We need at least 1MB, DDR would be hard I think, maybe an SRAM. Simulatable and synthesizable.

Notes:
- We need 1MB of BRAM to be available as SRAM


## Keywords
**BRAM** - Block RAM. This is available in FPGAs

**RAM** - Random Access Memory
- Data is lost when power is lost.

**SRAM** - Static RAM
- State of each bit is stored in a flip-flop
- Faster, more expensive, less dense, simpler

**DRAM** - Dynamic RAM
- State of each bit is stored in a transistor + capacitor
- Slower, cheaper, more dense, more complex

**DDR RAM** - Fancy modern DRAM

## Von neuman architecture
Data and instructions are stored in same block of memory

## Questions
**What happens when you give the CPU an instruction?**
Simple version
1. CPU receives instruction pointer (memory address)
2. CPU gets 32-bit binary instruction from memory address
3. 32-bit binary is parsed into its parts: CPU gets the opcode, registers, immediate values, etc
4. Perform arithmetic on values. Example: `r1 + r4, 4 << 1, 7 ^ &0x23`
5. Write the result to a register, or memory address
6. Repeat

Considerations
- Keeping state: condition flags, program counter, stack pointer, etc. Has to be done by CPU
- Keeps pointer to next instruction to execute. Next instruction can be a function of the current instruction. Example: a jump instruction.
- Pipelining: Instruction moves from fetch, to decode, to execute.

## Implementation overview
1. ROM chip - outside CPU
2. RAM chip - outside CPU
3. Fetch instruction chip
4. Decode chip
5. Execute chip
6. ALU chip

**ROM chip**
Input: select_memory_address
Output: *select_memory_address
Implementation: Big-ass mux outputs the value of a selected register. Holds one million registers in the case of a 1MB ROM chip.
MUX 000101

**Fetch instruction chip**
Input: instruction memory address
Output: 32-bit binary instruction 

**Decode chip**
Input: 32-bit binary instruction
Output: opcode/mnemonic, register_a, register_b, register_c, memory_address_a, memory_address_b, memory_address_c, imm_value_a, imm_value_b, condition

**Execute chip**
Input: opcode/mnemonic, register_a, register_b, register_c, memory_address_a, memory_address_b, memory_address_c, imm_value_a, imm_value_b, condition
Output: next_instruction

**RAM Chip**
Contains data (and instructions in a Von neumon architecture)
Input: select_memory_address, should_write, value 
Output: RAM[select_memory_address] 

**Notes**
- clock is outside cpu, and shared between cpu components
- control unit maintains pipeline state: which pipeline stage are we doing now? decode, fetch, alu, etc.... maybe we should do everything each clock cycle instead?
- register unit implementation similar to ram
- control unit maintains cpu state? I thought it contained fetch, decode, execute logic

# Bootrom
> Coding a bootrom(Assembler, 40) -- This allows code download into RAM over the serial port, and is baked into the FPGA image. Cute test programs run on this.

---

# Section 4: Compiler: A “high” level language -- 3 weeks
> Building a C compiler(Haskell, 2000) -- A bit more interesting, cover the basics of compiler design. Write in haskell. Write a parser. Break this into subchapters. Outputs ARM assembly.

Overview: Tokenize -> Parse -> Build AST -> Generate ARM

Compiler explanation
High level overview: source code -> executable
Compilation outside of programming?: structure text, act on it.
Before compilation, program (code) is nothing more than a list of characters
We need a way to structure these characters, make sense of them, and execute them

/* programmer code
name = "john"
print("hello", name)
*/
->
/* arm code
name string
mov "john", name
...
*/
Compiler needs to transform the source code into something useful, executable. In this case, executable is ASM (assembly) code

assembler
asm: mov r1, #5 -> bin: 0100110101001101


Compilation steps:

1. Tokenize
Source code -> List of tokens
Ex: 'var name = "hello" ' -> [Token{Type: 'identifier', literal: 'name'}, Token{Type: 'equals', literal: '='}, ...]

2. Build AST
Ex: [Token{Type: 'identifier', literal: 'name'}, Token{Type: 'equals', literal: '='}, ...] ->

Something like this???
Root{
  FunctionCall(
    Expression(Literal: 4),
    Expression(
      Operation(
        Type: SUM,
        A: Expression(Literal: 4),
        B: Expression(Literal: 10)
      )
    )
Let's figure out the structure of an AST...

3. Transform AST

4. Generate ASM

