`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 12:07:17
// Design Name: 
// Module Name: mac_sobel_pipe_stage
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


module mac_sobel_pipe_stage(
    input i_clk,
    input i_rst,
    
    //upstream
    input [71:0]i_data,
    input i_data_valid,
    output o_data_ready,
    
    //downstream
    output [15:0]o_data_1,
    output [15:0]o_data_2,
    output o_data_valid,
    input i_data_ready
    );
    
    integer i; 
    reg [7:0] kernel1 [8:0];
    reg [7:0] kernel2 [8:0];
    reg [15:0] multData1[8:0];
    reg [15:0] multData2[8:0];
    reg [15:0] sumDataInt1;
    reg [15:0] sumDataInt2; 
    
    reg valid_data;
    
    initial
    begin
        kernel1[0] =  1;
        kernel1[1] =  0;
        kernel1[2] = -1;
        kernel1[3] =  2;
        kernel1[4] =  0;
        kernel1[5] = -2;
        kernel1[6] =  1;
        kernel1[7] =  0;
        kernel1[8] = -1;
        
        kernel2[0] =  1;
        kernel2[1] =  2;
        kernel2[2] =  1;
        kernel2[3] =  0;
        kernel2[4] =  0;
        kernel2[5] =  0;
        kernel2[6] = -1;
        kernel2[7] = -2;
        kernel2[8] = -1;
    end    
    
    always @(posedge i_clk)
    begin
        if(i_rst)
        begin
            for(i=0; i<9; i=i+1)
            begin
                multData1[i] <= 0;
                multData2[i] <= 0;
            end
        end
        else
        begin
            if(i_data_valid & o_data_ready)
            begin
                for(i=0;i<9;i=i+1)
                begin
                    multData1[i] <= $signed(kernel1[i])*$signed({1'b0,i_data[i*8+:8]});
                    multData2[i] <= $signed(kernel2[i])*$signed({1'b0,i_data[i*8+:8]});
                end
            end
        end
    end
    
    
    always @(*)
    begin
        sumDataInt1 = 0;
        sumDataInt2 = 0;
        for(i=0;i<9;i=i+1)
        begin
            sumDataInt1 = $signed(sumDataInt1) + $signed(multData1[i]);
            sumDataInt2 = $signed(sumDataInt2) + $signed(multData2[i]);
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
    
    assign o_data_1 = sumDataInt1;
    assign o_data_2 = sumDataInt2;
    
    
endmodule
