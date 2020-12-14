`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2020 14:55:20
// Design Name: 
// Module Name: neighborhood_processing
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


module neighborhood_processing #(parameter imgWidth = 512, imgHeight = 512, filterType = "sobel")(

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
 
 
  wire [71:0]o_pixel_data_lb;
  wire o_pixel_data_valid_lb;
 
  wire o_r2g_data_valid;
  wire [7:0]o_r2g_data;
  wire lb_gray_data_req;
  wire filter_data_req;
    
    rgb2gray r2g1(
     .i_clk(i_clk),
     .i_rst(i_rst),
  
     .i_rgb_data_valid(i_data_valid),
     .i_rgb_data(i_data),
     .o_rgb_data_ready(o_data_ready),
  
     .o_gray_data_valid(o_r2g_data_valid),
     .o_gray_data(o_r2g_data),
     .i_gray_data_ready(lb_gray_data_req)
    );    
    
    line_buffer_controller #(.imgWidth(imgWidth), .imgHeight(imgHeight)) ctrl(
      .i_clk(i_clk),
      .i_rst(i_rst),
      
      .i_pixel_data_valid(o_r2g_data_valid),
      .i_pixel_data(o_r2g_data),
      .o_pixel_data_ready(lb_gray_data_req),
      
      .o_pixel_data_valid(o_pixel_data_valid_lb),
      .o_pixel_data(o_pixel_data_lb),
      .i_pixel_data_ready(filter_data_req)
    );
  
   
    generate
       if(filterType == "boxBlur")
       begin:bblur
       
         box_blur_filter bb(
            .i_clk(i_clk),
            .i_rst(i_rst),
            
            //upstream
            .i_pixel_data(o_pixel_data_lb),
            .i_pixel_data_valid(o_pixel_data_valid_lb),
            .o_pixel_data_ready(filter_data_req),
            
            //downstream
            .o_convolved_data(o_data),
            .o_convolved_data_valid(o_data_valid),
            .i_pixel_data_ready(i_data_ready)
         );  
       end
       
       else if(filterType == "sobel")
       begin:sobel
       
         sobel_filter sf(
            .i_clk(i_clk),
            .i_rst(i_rst),
            
            //upstream
            .i_pixel_data(o_pixel_data_lb),
            .i_pixel_data_valid(o_pixel_data_valid_lb),
            .o_pixel_data_ready(filter_data_req),
            
            //downstream
            .o_sobel_data(o_data),
            .o_sobel_data_valid(o_data_valid),
            .i_sobel_data_ready(i_data_ready)
         );          
       end
       
       else if(filterType == "gaussianBlur")
       begin: gblur
         
         gaussian_blur_filter gb(
             .i_clk(i_clk),
             .i_rst(i_rst),
             
             //upstream
             .i_pixel_data(o_pixel_data_lb),
             .i_pixel_data_valid(o_pixel_data_valid_lb),
             .o_pixel_data_ready(filter_data_req),
             
             //downstream
             .o_convolved_data(o_data),
             .o_convolved_data_valid(o_data_valid),
             .i_pixel_data_ready(i_data_ready)    
         );
            
       end
       
       else if(filterType == "sharpen")
       begin: sharp
       
         sharpen_filter sh(        
             .i_clk(i_clk),
             .i_rst(i_rst),
           
             //upstream
             .i_pixel_data(o_pixel_data_lb),
             .i_pixel_data_valid(o_pixel_data_valid_lb),
             .o_pixel_data_ready(filter_data_req),
           
              //downstream
             .o_convolved_data(o_data),
             .o_convolved_data_valid(o_data_valid),
             .i_pixel_data_ready(i_data_ready)    
         );  
       
       end
       
    endgenerate
 
 
endmodule
