`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.12.2020 23:02:13
// Design Name: 
// Module Name: pipe_stage_MAC_sharp
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


module pipe_stage_MAC_sharp(

    input i_clk,
    input i_rst,
    
    //upstream
    input [71:0]i_data,
    input i_data_valid,
    output o_data_ready,
    
    //downstream
    output [15:0]o_data,
    output o_data_valid,
    input i_data_ready

);
    integer i; 
    reg [7:0] kernel [8:0];
    reg [15:0] multData[8:0];
    reg [15:0] sumDataInt;
    
    reg valid_data;
    
    initial
    begin
        kernel[0] =  -1;
        kernel[1] =  -1;
        kernel[2] =  -1;
        kernel[3] =  -1;
        kernel[4] =  9;
        kernel[5] =  -1;
        kernel[6] =  -1;
        kernel[7] =  -1;
        kernel[8] =  -1;
    end    
    
    always @(posedge i_clk)
    begin
        if(i_rst)
        begin
            for(i=0; i<9; i=i+1)
            begin
                multData[i] <= 0;
            end
        end
        else
        begin
            if(i_data_valid & o_data_ready)
            begin
                for(i=0;i<9;i=i+1)
                begin
                    multData[i] <= $signed(kernel[i])*$signed({1'b0,i_data[i*8+:8]});
                end
            end
        end
    end
    
    
    always @(*)
    begin
        sumDataInt = 0;
        for(i=0;i<9;i=i+1)
        begin
            sumDataInt = $signed(sumDataInt) + $signed(multData[i]);
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
    
    assign o_data = sumDataInt;
    
    
endmodule
