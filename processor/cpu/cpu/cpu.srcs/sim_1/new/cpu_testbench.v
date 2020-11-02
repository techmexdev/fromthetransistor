`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2020 03:08:55 PM
// Design Name: 
// Module Name: cpu_testbench
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
//////////////////////////////////////////////////////////////////////////////////



module cpu_testbench;

reg clock = 0;
reg [19:0] memory_address = 0;
reg should_write = 0;
reg [31:0] i_data;
wire [31:0] o_data;

always #5
begin
    clock <= ~clock;
end

ram ram_chip(
    .i_clock(clock),
    .i_memory_address(memory_address),
    .i_should_write(ram_should_write),
    .i_data(ram_in_data),
    .o_data(ram_out_data)
);

register register_chip(
    .i_clock(clock),
    .i_sel(reg_sel),
    .i_should_write(reg_should_write),
    .i_data(reg_in_data),
    .o_data(reg_out_data)
);

program_counter program_counter_chip(
    .i_clock(clock),
    .i_next_inst_addr(inst_next_inst_addr),
    .i_should_jump(should_jump),
    .i_should_reset(should_reset),
    .o_instruction(pc_out_inst_addr)
);

control_unit control_unit_chip(
    
);

fetcher fetch_chip(
    .i_clock(clock),
    .i_instruction_pointer(pc_out_inst_addr),
    .i_memory(ram_chip),
    .o_instruction(curr_instruction)
);

decoder decode_chip(
    .i_instruction(curr_instruction),
    .o_opcode(inst_opcode),
    .o_condition(inst_condition),
    .o_next_instruction_address(inst_next_inst_addr),
    .o_should_jump(inst_should_jump),
    .o_data_a(inst_data_a),
    .o_data_b(inst_data_b),
    .o_should_write_reg(inst_should_write_reg),
    .o_should_write_mem(inst_should_write_mem),
    .o_dest_register(inst_dest_register),
    .o_dest_mem_address(inst_dest_mem_address),
    .o_imm_value(inst_imm_value)
);

alu alu_chip(
    .i_opcode(inst_opcode),
    .i_condition(inst_condition),
    .i_data_a(inst_data_a),
    .o_data_b(inst_data_b),
    .i_imm_value(inst_imm_value),
    .o_data(alu_out_data)
);

// can write to either RAM or register
executer execute_chip(
    .i_clock(clock),
    .i_should_write_reg(inst_should_write_reg),
    .i_should_write_mem(inst_should_write_mem),
    .i_reg(inst_dests_reg),
    .i_memory_address(inst_dest_mem_address),
    .i_data(alu_out_data),
    .i_reg_chip(register_chip),
    .i_mem_chip(ram_chip)
);

initial
begin
    // Initially empty
    memory_address = 20'b00000000000000000000;
    #20    
    if (o_data != 32'b00000000000000000000000000000000)
    begin
        $display("Test failed :(");
    end
    
end
endmodule