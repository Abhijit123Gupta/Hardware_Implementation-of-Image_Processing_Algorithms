`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2020 15:17:56
// Design Name: 
// Module Name: point_processing
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


module point_processing #(parameter filterType = "inversion")(

 input i_clk,
 input i_rst,
 
 //upstream
 input i_data_valid,
 input [23:0]i_data,
 output o_data_ready,
 
 //downstream
 output o_data_valid,
 output [7:0]o_data,
 input i_data_ready

);
 
 wire o_gray_data_valid;
 wire i_filter_data_ready;
 wire [7:0]o_gray_data;

 rgb2gray r2g2(
   .i_clk(i_clk),
   .i_rst(i_rst),
    
    //upstream
   .i_rgb_data_valid(i_data_valid),
   .i_rgb_data(i_data),
   .o_rgb_data_ready(o_data_ready),
    
    //downstream
   .o_gray_data_valid(o_gray_data_valid),
   .o_gray_data(o_gray_data),
   .i_gray_data_ready(i_filter_data_ready)
 ); 

 generate 
    if(filterType == "inversion")
    begin
        inversion f1(
             .i_clk(i_clk),
             .i_rst(i_rst),
        
        //upstream
            .i_data_valid(o_gray_data_valid),
            .i_data(o_gray_data),
            .o_data_ready(i_filter_data_ready),
        
        //downstream
            .o_data_valid(o_data_valid),
            .o_data(o_data),
            .i_data_ready(i_data_ready)
        );    
    end
    
    else if(filterType == "inc_contrast")
    begin
        contrast_inc f2(
             .i_clk(i_clk),
             .i_rst(i_rst),
        
        //upstream
            .i_data_valid(o_gray_data_valid),
            .i_data(o_gray_data),
            .o_data_ready(i_filter_data_ready),
        
        //downstream
            .o_data_valid(o_data_valid),
            .o_data(o_data),
            .i_data_ready(i_data_ready)
        );
    end
    
    else if(filterType == "dec_contrast")
    begin
        contrast_dec f3(
             .i_clk(i_clk),
             .i_rst(i_rst),
        
        //upstream
            .i_data_valid(o_gray_data_valid),
            .i_data(o_gray_data),
            .o_data_ready(i_filter_data_ready),
        
        //downstream
            .o_data_valid(o_data_valid),
            .o_data(o_data),
            .i_data_ready(i_data_ready)
        );
    end
 endgenerate     
 
    
endmodule
