`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.12.2020 19:12:06
// Design Name: 
// Module Name: gaussian_blur_filter
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


 module gaussian_blur_filter(

    input        i_clk,
    input        i_rst,
    
    //upstream
    input [71:0] i_pixel_data,
    input        i_pixel_data_valid,
    output       o_pixel_data_ready,
    
    //downstream
    output  [7:0]o_convolved_data,
    output       o_convolved_data_valid,
    input        i_pixel_data_ready
 );
 
 wire [15:0]o_MAC_data, o_buff_data;
 wire o_MAC_data_valid, o_buff_data_valid; 
 wire conv_data_req, buff_data_req;
     
       
 pipe_stage_MAC_gblur gb1(
     .i_clk(i_clk),
     .i_rst(i_rst),
     
     //upstream
     .i_data(i_pixel_data),
     .i_data_valid(i_pixel_data_valid),
     .o_data_ready(o_pixel_data_ready),
     
     //downstream
     .o_data(o_MAC_data),
     .o_data_valid(o_MAC_data_valid),
     .i_data_ready(buff_data_req)
  );  
 
 pipe_stage_buff_gblur gb2(
    
    .i_clk(i_clk),
    .i_rst(i_rst),
  
    //upstream
    .i_data(o_MAC_data),
    .i_data_valid(o_MAC_data_valid),
    .o_data_ready(buff_data_req),
    
    //downstream
    .o_data(o_buff_data),
    .o_data_valid(o_buff_data_valid),
    .i_data_ready(conv_data_req)
 
 );
         
 pipe_stage_conv_gblur gb3(
     .i_clk(i_clk),
     .i_rst(i_rst),
     
     //upstream
     .i_data(o_buff_data),
     .i_data_valid(o_buff_data_valid),
     .o_data_ready(conv_data_req),
     
     //downstream
     .o_data(o_convolved_data),
     .o_data_valid(o_convolved_data_valid),
     .i_data_ready(i_pixel_data_ready) 
  );
 
 
 
 endmodule
