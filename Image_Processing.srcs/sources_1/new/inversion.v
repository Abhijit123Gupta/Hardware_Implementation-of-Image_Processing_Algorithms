`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2020 21:18:41
// Design Name: 
// Module Name: inversion
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


module inversion(

 input i_clk,
 input i_rst,
 
 //upstream
 input i_data_valid,
 input [7:0]i_data,
 output o_data_ready,
 
 //downstream
 output o_data_valid,
 output [7:0]o_data,
 input i_data_ready

    );
    
    reg valid_data;
    reg [7:0]inv_pixel_data;
    
    always @(posedge i_clk)
    begin
        if(i_rst)
        begin
            inv_pixel_data <= 0;
        end
        else
        begin
            if(i_data_valid & o_data_ready)
            begin
                inv_pixel_data <= 8'hff - i_data;    
            end
        end
    end
    
    always @(posedge i_clk)
    begin
        if(i_rst)
            valid_data <= 0;
        else if(i_data_valid & !valid_data)
            valid_data <= 1;
        else if(i_data_ready & valid_data)
            valid_data <= i_data_valid; 
    end
    
    assign o_data_ready = ~valid_data | i_data_ready ;
    assign o_data_valid = valid_data; 
    
    assign o_data = inv_pixel_data;   
    
endmodule
