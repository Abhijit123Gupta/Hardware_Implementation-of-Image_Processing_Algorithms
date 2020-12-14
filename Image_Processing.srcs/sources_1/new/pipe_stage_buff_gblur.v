`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.12.2020 19:40:25
// Design Name: 
// Module Name: pipe_stage_buff_gblur
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


 module pipe_stage_buff_gblur(
    input i_clk,
    input i_rst,
    
    //upstream
    input [15:0]i_data,
    input i_data_valid,
    output o_data_ready,
    
    //downstream
    output [15:0]o_data,
    output o_data_valid,
    input i_data_ready

 );
    
    reg valid_data;
    reg [15:0]buff_data;
    
    always @(posedge i_clk)
    begin
        if(i_rst)
        begin
            buff_data <= 0;
        end
        else
        begin
            if(i_data_valid & o_data_ready)
            begin
                buff_data <= i_data;
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
    
    assign o_data = buff_data;    
    
endmodule
