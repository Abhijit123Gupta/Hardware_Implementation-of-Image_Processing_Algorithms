`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 12:09:47
// Design Name: 
// Module Name: thresh_sobel_pipe_stage
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


module thresh_sobel_pipe_stage(
    input i_clk,
    input i_rst,
    
    //upstream
    input [31:0]i_data,
    input i_data_valid,
    output o_data_ready,
    
    //downstream
    output [7:0]o_data,
    output o_data_valid,
    input i_data_ready

    );
    
    reg [7:0]o_thresh_data;
    reg valid_data;
    
    always @(posedge i_clk)
    begin
        if(i_data_valid & o_data_ready)
        begin
            if(i_data > 4000)
                o_thresh_data <= 8'hff;
            else
                o_thresh_data <= 8'h00;
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
    
    assign o_data = o_thresh_data;
    
endmodule
