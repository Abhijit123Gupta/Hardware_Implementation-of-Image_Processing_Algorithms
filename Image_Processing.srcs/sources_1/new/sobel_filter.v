`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 12:04:44
// Design Name: 
// Module Name: sobel_filter
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


module sobel_filter(
    input        i_clk,
    input        i_rst,
    
    //upstream
    input [71:0] i_pixel_data,
    input        i_pixel_data_valid,
    output       o_pixel_data_ready,
    
    //downstream
    output  [7:0]o_sobel_data,
    output       o_sobel_data_valid,
    input        i_sobel_data_ready
 );
 
 wire [15:0]mac_data_1, mac_data_2;
 wire mac_data_valid;
 wire con_data_ready;
 
 wire [31:0]con_data;
 wire con_data_valid;
 
 
 mac_sobel_pipe_stage s1(
     .i_clk(i_clk),
     .i_rst(i_rst),
     
     //upstream
     .i_data(i_pixel_data),
     .i_data_valid(i_pixel_data_valid),
     .o_data_ready(o_pixel_data_ready),
     
     //downstream
     .o_data_1(mac_data_1),
     .o_data_2(mac_data_2),
     .o_data_valid(mac_data_valid),
     .i_data_ready(con_data_ready)
 );
 
 con_sobel_pipe_stage s2(
     .i_clk(i_clk),
     .i_rst(i_rst),
     
     //upstream
     .i_data_1(mac_data_1),
     .i_data_2(mac_data_2),
     .i_data_valid(mac_data_valid),
     .o_data_ready(con_data_ready),
     
     //downstream
     .o_data(con_data),
     .o_data_valid(con_data_valid),
     .i_data_ready(thresh_data_ready)
 
 );
 
 thresh_sobel_pipe_stage s3(
     .i_clk(i_clk),
     .i_rst(i_rst),
     
     //upstream
     .i_data(con_data),
     .i_data_valid(con_data_valid),
     .o_data_ready(thresh_data_ready),
     
     //downstream
     .o_data(o_sobel_data),
     .o_data_valid(o_sobel_data_valid),
     .i_data_ready(i_sobel_data_ready)
 
 );
 
 
endmodule
