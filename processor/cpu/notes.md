# ARM7 CPU 

Building a ARM7 CPU(Verilog, 1500) -- Break this into subchapters. A simple pipeline to start, decode, fetch, execute. How much BRAM do we have? We need at least 1MB, DDR would be hard I think, maybe an SRAM. Simulatable and synthesizable.

Notes:
- We need 1MB of BRAM to be available as SRAM


### Keywords:
**BRAM**: Block RAM. This is available in FPGAs

**RAM**: Random Access Memory
- Data is lost when power is lost.

**SRAM**: Static RAM
- State of each bit is stored in a flip-flop
- Faster, more expensive, less dense, simpler

**DRAM**: Dynamic RAM
- State of each bit is stored in a transistor + capacitor
- Slower, cheaper, more dense, more complex

**DDR RAM**: Fancy modern DRAM

**Von neuman architecture**
- Data and instructions are stored in same block of memory

### Questions
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

### Implementation overview
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
