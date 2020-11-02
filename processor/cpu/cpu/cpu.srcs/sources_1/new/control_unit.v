`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2020 03:26:11 PM
// Design Name: 
// Module Name: control_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 

/*

**Decode**
Input: 32-bit binary instruction
Output: opcode/mnemonic, register_a, register_b, register_c, memory_address_a, memory_address_b, memory_address_c, imm_value_a, imm_value_b, condition

**Execute**
Input: opcode/mnemonic, register_a, register_b, register_c, memory_address_a, memory_address_b, memory_address_c, imm_value_a, imm_value_b, condition
Output: next_instruction
*/
//////////////////////////////////////////////////////////////////////////////////

module control_unit #(parameter ADDRESS_DEPTH=1000)(
    input wire [19:0] i_instruction,
    input reg [31:0] memory [11:0],
    output reg [31:0] o_next_instruction,
    output reg [31:0] register_a,
    );
    
reg opcode;
reg register_a;
reg register_b;
reg register_c;
reg memory_address_a; 
reg memory_address_b;
reg memory_address_c; 
reg imm_value_a;
reg imm_value_b;
reg condition;

reg clock;

always #5
begin
    clock <= ~clock;
end

always @(posedge clock)
begin
   // DECODE
   
    localparam MOV_IMM_REG = 7'b0011101;
   
    /*
    1110 00 1 1101 0 0000 0010 000000000101 # mov r2, #5
    ____ _________ _ ____ ____ ____________
    cond   inst    S 0000  Rd      imm12
    */
    reg [3:0] cond;
    reg [6:0] opcode;
    reg [1:0] state;
    
    
    
    opcode = i_instruction[10:4]; // sequential assignment; wait until next clock cycle so value is written to register
    cond <= i_instruction[3:0];
    state <= i_instruction[12:11];
    
    case ({opcode})
      7'b0011101:
        begin 
          register_a <= i_instruction[19:16];
          imm_value_a <= i_instruction[31:19];
        end
      default :
        // no-op
        begin
        end
    endcase
     
     
     
    // EXECUTE
    // registers in decode phase will be written after this clock cycle
    case ({opcode})
        7'b0011101:
        begin 
          register[register_a] <= imm_value_a;
        end
      default :
        // no-op
        begin
        end  
    endcase
    
end

endmodule

