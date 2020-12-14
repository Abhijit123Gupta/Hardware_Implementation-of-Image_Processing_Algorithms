`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.09.2020 12:16:44
// Design Name: 
// Module Name: rgb2gray
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


module rgb2gray(
 input i_clk,
 input i_rst,
 
 //upstream
 input i_rgb_data_valid,
 input [23:0]i_rgb_data,
 output o_rgb_data_ready,
 
 //downstream
 output o_gray_data_valid,
 output reg [7:0]o_gray_data,
 input i_gray_data_ready
 
    );
    
 wire [7:0]R_component, G_component, B_component;
 reg valid_data;
 
 assign R_component =  i_rgb_data[7:0];
 assign G_component =  i_rgb_data[15:8];
 assign B_component =  i_rgb_data[23:16];
    
 always @(posedge i_clk)
 begin
    if(i_rst)
    begin
        o_gray_data <= 0;
    end
    else
    begin
        if(i_rgb_data_valid & o_rgb_data_ready)
        begin
            o_gray_data <= (R_component>>2)+(R_component>>5)+(G_component>>1)+(G_component>>4)+(B_component>>4)+(B_component>>5);
        end
    end
 end   
 
 always @(posedge i_clk)
 begin
    if(i_rst)
        valid_data <= 0;
    else if(i_rgb_data_valid & !valid_data)
        valid_data <= 1;
    else if(i_gray_data_ready & valid_data)
        valid_data <= i_rgb_data_valid;    
 end
 
 assign o_rgb_data_ready = ~valid_data | i_gray_data_ready ;
 assign o_gray_data_valid = valid_data; 
    
endmodule
