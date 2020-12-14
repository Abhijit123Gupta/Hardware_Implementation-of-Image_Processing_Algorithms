`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.09.2020 13:41:35
// Design Name: 
// Module Name: convolve_avg
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


 module box_blur_filter(
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
        
    wire [15:0]o_MAC_data;
    wire o_MAC_data_valid;
    wire conv_data_req;
    
      
    pipe_stage_MAC mac(
        .i_clk(i_clk),
        .i_rst(i_rst),
        
        //upstream
        .i_data(i_pixel_data),
        .i_data_valid(i_pixel_data_valid),
        .o_data_ready(o_pixel_data_ready),
        
        //downstream
        .o_data(o_MAC_data),
        .o_data_valid(o_MAC_data_valid),
        .i_data_ready(conv_data_req)
 );  
        
    pipe_stage_conv con(
        .i_clk(i_clk),
        .i_rst(i_rst),
        
        //upstream
        .i_data(o_MAC_data),
        .i_data_valid(o_MAC_data_valid),
        .o_data_ready(conv_data_req),
        
        //downstream
        .o_data(o_convolved_data),
        .o_data_valid(o_convolved_data_valid),
        .i_data_ready(i_pixel_data_ready) 
 );
     
 endmodule
