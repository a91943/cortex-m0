`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2023 12:28:06 PM
// Design Name: 
// Module Name: top_layer
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


module top_layer(
    input clk, rst_n,
    output wire [3:0] o_bits,
    output wire o_int_act,
    input wire [1:0] i_exti // buttons
    );
    
  // Wires for datapath to control_unit connections
  wire i_we_ir_datapath;
  wire i_we_cr_datapath;
  wire i_re_cr_datapath;
  wire [1:0] i_addr1_mux_datapath;
  wire i_addr2_mux_datapath;
  wire [1:0] i_data_mux_datapath;
  wire [3:0] i_alu_opcode_datapath;
  wire [1:0] i_alu_input_datapath;
  wire [15:0] o_instructions_datapath;
  wire w_we_pc;
  wire [1:0] w_mux_pc;
  wire w_re_ram;
  wire w_we_ram;

  // NVIC
  wire w_isrComplete, w_interruptActive;
  wire [7:0] w_interrupt;
  
  assign w_interrupt[7:2] = 0;
  assign w_interrupt[1:0] = i_exti;
  assign o_int_act = w_interruptActive;

  nvic nvic(
    .clk(clk),
    .rst_n(rst_n),
    .i_isrComplete(w_isrComplete),
    .i_interrupt(w_interrupt),
    .o_interruptAcknowledge(o_interruptAcknowledge),
    .o_interruptActive(w_interruptActive)
  );

  // Instantiate datapath module
  datapath datapath_inst (
    .clk(clk),
    .rst_n(rst_n),
    .i_we_ir(i_we_ir_datapath),
    .i_we_cr(i_we_cr_datapath),
    .i_re_cr(i_re_cr_datapath),
    .i_addr1_mux(i_addr1_mux_datapath),
    .i_addr2_mux(i_addr2_mux_datapath),
    .i_data_mux(i_data_mux_datapath),
    .i_alu_opcode(i_alu_opcode_datapath),
    .i_alu_input(i_alu_input_datapath),
    .o_instructions(o_instructions_datapath),
    .o_bits(o_bits),
    
    .i_re_ram(w_re_ram), 
    .i_we_ram(w_we_ram),
    
    .i_we_pc(w_we_pc),
    .i_mux_pc(w_mux_pc)
  );

  // Instantiate control_unit module
  control_unit control_unit_inst (
    .clk(clk),
    .rst_n(rst_n),
    .i_instructions(o_instructions_datapath),
    .o_we_ir(i_we_ir_datapath),
    .o_we_cr(i_we_cr_datapath),
    .o_re_cr(i_re_cr_datapath),
    .o_addr1_mux(i_addr1_mux_datapath),
    .o_addr2_mux(i_addr2_mux_datapath),
    .o_data_mux(i_data_mux_datapath),
    .o_alu_opcode(i_alu_opcode_datapath),
    .o_alu_input(i_alu_input_datapath),
    
    .o_re_ram(w_re_ram),
    .o_we_ram(w_we_ram),
    
    .o_we_pc(w_we_pc),
    .o_mux_pc(w_mux_pc),
    
    .o_isr_complete(w_isrComplete),
    .i_interrupt_active(w_interruptActive)
  );

endmodule


