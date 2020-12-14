`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.09.2020 14:22:55
// Design Name: 
// Module Name: image_processing_top
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

//`include "design_parameters.v"

module image_processing_top #(parameter imageWidth = 512, imageHeight = 512, processingType = "neighborhood", filterType = "boxBlur")(

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
 

 generate
    if(processingType == "RGB2GRAY")
    begin
        rgb2gray r2g0(
           .i_clk(i_clk),
           .i_rst(i_rst),
            
            //upstream
           .i_rgb_data_valid(i_data_valid),
           .i_rgb_data(i_data),
           .o_rgb_data_ready(o_data_ready),
            
            //downstream
           .o_gray_data_valid(o_data_valid),
           .o_gray_data(o_data),
           .i_gray_data_ready(i_data_ready)
        );    
    end
    
    else if(processingType == "neighborhood")
    begin
        neighborhood_processing #(.imgWidth(imageWidth), .imgHeight(imageHeight), .filterType(filterType)) np(
            .i_clk(i_clk),
            .i_rst(i_rst),
            
            //upstream
            .i_data_valid(i_data_valid),
            .i_data(i_data),
            .o_data_ready(o_data_ready),
            
            //downstream
            .o_data_valid(o_data_valid),
            .o_data(o_data),
            .i_data_ready(i_data_ready)
        );
    
    end
    else if(processingType == "point")
    begin
        point_processing #(.filterType(filterType)) pp(
            .i_clk(i_clk),
            .i_rst(i_rst),
            
            //upstream
            .i_data_valid(i_data_valid),
            .i_data(i_data),
            .o_data_ready(o_data_ready),
            
            //downstream
            .o_data_valid(o_data_valid),
            .o_data(o_data),
            .i_data_ready(i_data_ready)
        );
    
    end
 endgenerate

 
 
     

endmodule
