`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.09.2020 14:28:35
// Design Name: 
// Module Name: line_buffer_controller
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


module line_buffer_controller #(parameter imgWidth = 512, imgHeight = 512)(

 input i_clk,
 input i_rst,
 
 //upstream
 input i_pixel_data_valid,
 input [7:0]i_pixel_data,
 output o_pixel_data_ready,
 
 //downstream
 output o_pixel_data_valid,
 output reg [71:0]o_pixel_data,
 input i_pixel_data_ready
    );
   
 parameter cnt_depth = $clog2(imgWidth);
 parameter tot_cnt_depth = $clog2(imgWidth*imgHeight);
 
 reg [cnt_depth:0]pixel_wr_count, pixel_rd_count; 
 reg [3:0]line_buffer_valid_in; 
 reg [1:0]currWrLineBuff;           // 4 line buffers are used to improve efficeincy
 reg [1:0]currRdLineBuff;
 reg [tot_cnt_depth:0]totalPixelCounter;
 reg [3:0]line_buffer_rd_valid;
 wire [23:0]lb3_data, lb2_data, lb1_data, lb0_data;
 reg rd_line_buffer;
 reg rdState;
 
 assign o_pixel_data_valid = rd_line_buffer; 
 assign o_pixel_data_ready = i_pixel_data_ready;
 
 always @(posedge i_clk)
 begin
     if(i_rst)
         totalPixelCounter <= 0;
     else
     begin
         if(i_pixel_data_valid & !rd_line_buffer)
             totalPixelCounter <= totalPixelCounter + 1;
         else if(!i_pixel_data_valid & rd_line_buffer)
             totalPixelCounter <= totalPixelCounter - 1;
     end
 end
 
 always @(posedge i_clk)
 begin
    if(i_rst)
        rd_line_buffer <= 0;
    else
    begin
        if(totalPixelCounter >= (3*(imgWidth+2)-1) & pixel_wr_count!=(imgWidth-1) & pixel_wr_count!=(imgWidth))
            rd_line_buffer <= 1;
        else
            rd_line_buffer <= 0;        
    end            
 end
 
 
 // Writing to the Line buffer   
 always @(posedge i_clk)
 begin
    if(i_rst)
    begin
        currWrLineBuff <= 2'b00;
        pixel_wr_count <= 0;
    end
    else
    begin
        if(i_pixel_data_valid)
        begin                        
            if(pixel_wr_count == imgWidth+1)           //since each line buffer size is 514
            begin
                currWrLineBuff <= currWrLineBuff + 1;
                pixel_wr_count <= 0;
            end
            else
            begin
                pixel_wr_count <= pixel_wr_count+1;    
            end                
        end
    end
 end 
 
 always @(*)
 begin
    line_buffer_valid_in = 4'b0000;
    line_buffer_valid_in[currWrLineBuff] = i_pixel_data_valid; 
 end
 
 // Reading from Line Buffer
 always @(posedge i_clk)
 begin
    if(i_rst)
    begin
        pixel_rd_count <= 0;
        currRdLineBuff <= 0;
    end
    else
    begin
        if(rd_line_buffer)
        begin            
            if(pixel_rd_count == imgWidth-1)
            begin
                pixel_rd_count <= 0;
                currRdLineBuff <= currRdLineBuff + 1; 
            end
            else
                pixel_rd_count <= pixel_rd_count + 1; 
        end
    end
 end 
 
         
 always @(*)
 begin
    case(currRdLineBuff)
        2'b00: begin line_buffer_rd_valid[0] = rd_line_buffer;
                     line_buffer_rd_valid[1] = rd_line_buffer;
                     line_buffer_rd_valid[2] = rd_line_buffer;
                     line_buffer_rd_valid[3] = 1'b0;
                     o_pixel_data = {lb2_data, lb1_data, lb0_data};  end
                     
        2'b01: begin line_buffer_rd_valid[0] = 1'b0;
                     line_buffer_rd_valid[1] = rd_line_buffer;
                     line_buffer_rd_valid[2] = rd_line_buffer;
                     line_buffer_rd_valid[3] = rd_line_buffer;
                     o_pixel_data = {lb3_data, lb2_data, lb1_data};  end
                     
        2'b10: begin line_buffer_rd_valid[0] = rd_line_buffer;
                     line_buffer_rd_valid[1] = 1'b0;
                     line_buffer_rd_valid[2] = rd_line_buffer;
                     line_buffer_rd_valid[3] = rd_line_buffer;
                     o_pixel_data = {lb0_data, lb3_data, lb2_data};  end
                     
        2'b11: begin line_buffer_rd_valid[0] = rd_line_buffer;
                     line_buffer_rd_valid[1] = rd_line_buffer;
                     line_buffer_rd_valid[2] = 1'b0;
                     line_buffer_rd_valid[3] = rd_line_buffer;
                     o_pixel_data = {lb1_data, lb0_data, lb3_data};  end
    endcase
 end
 
        
 line_buffer #(.imgWidth(imgWidth), .imgHeight(imgHeight)) lb0(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_data(i_pixel_data),
    .i_data_valid(line_buffer_valid_in[0]),
    .o_data(lb0_data),
    .i_rd_data(line_buffer_rd_valid[0])
 );
 
 line_buffer #(.imgWidth(imgWidth), .imgHeight(imgHeight)) lb1(
     .i_clk(i_clk),
     .i_rst(i_rst),
     .i_data(i_pixel_data),
     .i_data_valid(line_buffer_valid_in[1]),
     .o_data(lb1_data),
     .i_rd_data(line_buffer_rd_valid[1])
  ); 
  
  line_buffer #(.imgWidth(imgWidth), .imgHeight(imgHeight)) lb2(
      .i_clk(i_clk),
      .i_rst(i_rst),
      .i_data(i_pixel_data),
      .i_data_valid(line_buffer_valid_in[2]),
      .o_data(lb2_data),
      .i_rd_data(line_buffer_rd_valid[2])
   ); 
   
   line_buffer #(.imgWidth(imgWidth), .imgHeight(imgHeight)) lb3(
       .i_clk(i_clk),
       .i_rst(i_rst),
       .i_data(i_pixel_data),
       .i_data_valid(line_buffer_valid_in[3]),
       .o_data(lb3_data),
       .i_rd_data(line_buffer_rd_valid[3])
    ); 
      
    
endmodule
