`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 12:09:05
// Design Name: 
// Module Name: con_sobel_pipe_stage
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


module con_sobel_pipe_stage(
    input i_clk,
    input i_rst,
    
    //upstream
    input [15:0]i_data_1,
    input [15:0]i_data_2,
    input i_data_valid,
    output o_data_ready,
    
    //downstream
    output [31:0]o_data,
    output o_data_valid,
    input i_data_ready
    );
    
    reg [31:0] convolved_data_int1;
    reg [31:0] convolved_data_int2;
    wire [31:0] convolved_data_int;
    reg valid_data;
    
    always @(posedge i_clk)
    begin
        if(i_rst)
        begin
            convolved_data_int1 <= 0;
            convolved_data_int2 <= 0;
        end
        else
        begin
            if(i_data_valid & o_data_ready)
            begin
                convolved_data_int1 <= $signed(i_data_1)*$signed(i_data_1);
                convolved_data_int2 <= $signed(i_data_2)*$signed(i_data_2);
            end
        end
    end
    
    assign convolved_data_int = convolved_data_int1+convolved_data_int2;

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
    
    assign o_data = convolved_data_int;
    
endmodule
