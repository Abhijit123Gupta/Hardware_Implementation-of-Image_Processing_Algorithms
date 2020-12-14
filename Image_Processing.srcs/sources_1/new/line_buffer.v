`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2020 11:03:00
// Design Name: 
// Module Name: line_buffer
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


module line_buffer #(parameter imgWidth = 512, imgHeight = 512)(

input i_clk,
input i_rst,
input [7:0]i_data,
input i_data_valid,
output [23:0]o_data,
input i_rd_data
    );

parameter ptr_depth = $clog2(imgWidth);

reg [7:0]buffer[0:imgWidth+1];
reg [ptr_depth :0]wr_ptr;
reg [ptr_depth :0]rd_ptr;

always @(posedge i_clk)
begin
    if(i_data_valid)
        buffer[wr_ptr] <= i_data;    
end  

always @(posedge i_clk)
begin
    if(i_rst)
        wr_ptr <= 0;    
    else if(i_data_valid)
    begin
        if(wr_ptr == imgWidth+1)
            wr_ptr <=0;
        else    
            wr_ptr <= wr_ptr + 1;
    end          
end           

assign o_data = {buffer[rd_ptr], buffer[rd_ptr+1], buffer[rd_ptr+2]};

always @(posedge i_clk)
begin
    if(i_rst)
        rd_ptr <= 0;
    else if(i_rd_data)
    begin
        if(rd_ptr == imgWidth-1)
            rd_ptr = 0;
        else    
            rd_ptr <= rd_ptr + 1;
    end
end 
    
endmodule

