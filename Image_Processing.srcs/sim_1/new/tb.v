`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.09.2020 21:59:10
// Design Name: 
// Module Name: tb
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

//define image dimensions
`define imageWidth 1280
`define imageHeight 720 

module tb(

    );
 
 //define the type of processing and filter to be applied   
 parameter processingType = "neighborhood";
 parameter filterType = "sharpen";
 
 
 reg clk;
 reg reset;
 reg [23:0] imgData;
 integer file,file1,i,j,k,x;
 reg imgDataValid;
 integer sentSize;
 integer pad_count;
 wire [7:0] OutData;
 wire OutDataValid;
 integer receivedData=0;
 initial
 begin
    clk = 1'b0;
    forever
    begin
        #5 clk = ~clk;
    end
 end
 
 initial
 begin
    reset = 1;
    sentSize = 0;
    pad_count = 0;
    imgDataValid = 0;
    #100;
    reset = 0;
    #100;
    file = $fopen("G:/verilog_files/Image_Processing/audi_color.bin","rb"); 
    file1 = $fopen("G:/verilog_files/Image_Processing/audi_sharp.bin","wb");
    
    if(processingType == "neighborhood")
    begin
        //sending top padding data
        for(k=0;k<`imageWidth+2;k=k+1)
        begin
            @(posedge clk);
            imgData <= 0;
            imgDataValid <= 1'b1;         
        end
     
        for(i=0; i<`imageHeight; i=i+1)
        begin
            //sending left padding data
            @(posedge clk);
            imgDataValid <= 1'b1;
            imgData <= 0;
            
            //sending pixel data
            for(j=0; j<`imageWidth; j=j+1)
            begin
                @(posedge clk);
                x=$fscanf(file,"%c%c%c",imgData[7:0],imgData[15:8],imgData[23:16]);
                imgDataValid <= 1'b1;
                sentSize <= sentSize + 1;
                //$display("image_data = %h",imgData);
            end
                
            //sending right padding data    
            @(posedge clk);
            imgDataValid <= 1'b1;
            imgData <= 0;            
        end
        
        
        //sending bottom padding data
        for(k=0;k<`imageWidth+2;k=k+1)
        begin
            @(posedge clk);
            imgData <= 0;
            imgDataValid <= 1'b1;          
        end
    end
    
    else //for point processing and RGB2GRAY filters
    begin
        for(j=0; j<`imageWidth * `imageHeight; j=j+1)
        begin
            @(posedge clk);
            x=$fscanf(file,"%c%c%c",imgData[7:0],imgData[15:8],imgData[23:16]);
            imgDataValid <= 1'b1;
            sentSize <= sentSize + 1;
            //$display("image_data = %h",imgData);
        end
    end
    
    
    @(posedge clk);
    imgDataValid <= 1'b0;
    $fclose(file);
 end
 
 always @(posedge clk)
 begin
     if(OutDataValid)
     begin
         $fwrite(file1,"%c",OutData);
         receivedData = receivedData+1;
     end 
     if(receivedData == `imageWidth * `imageHeight)
     begin
        $fclose(file1);
        $stop;
     end
 end
 

 image_processing_top #(.imageWidth(`imageWidth), .imageHeight(`imageHeight), .processingType(processingType), .filterType(filterType)) dut(
    .i_clk(clk),
    .i_rst(reset),
    //upstream
    .i_data_valid(imgDataValid),
    .i_data(imgData),
    .o_data_ready(),
    //downstream
    .o_data_valid(OutDataValid),
    .o_data(OutData),
    .i_data_ready(1'b1)
);  
 
 //integer p, count = 0, dis_count = 0;
 //always @(posedge clk)
 //begin   
    //$display(receivedData);
   /*
    if(dut.genblk1.np.ctrl.lb0.wr_ptr == 513)
    begin
        $write("lb0 :%h ",count);
        for(p=0; p<514; p=p+1)
        begin
            $write("%h",dut.genblk1.np.ctrl.lb0.buffer[p]);
            $write(" ");
        end
        count = count + 512;
        //$write(" ");    
        $display("");

    end
    
    if(dut.genblk1.np.ctrl.lb1.wr_ptr == 513)
    begin
        $write("lb1 :%h ",count);
        for(p=0; p<514; p=p+1)
        begin
            $write("%h",dut.genblk1.np.ctrl.lb1.buffer[p]);
            $write(" ");
        end
        count = count + 512;
        //$write(" ");    
        $display("");

    end
    
    if(dut.genblk1.np.ctrl.lb2.wr_ptr == 513)
    begin
        $write("lb2 :%h ",count);
        for(p=0; p<514; p=p+1)
        begin
            $write("%h",dut.genblk1.np.ctrl.lb2.buffer[p]);
            $write(" ");
        end
        count = count + 512;
        //$write(" ");    
        $display("");

    end
    
    if(dut.genblk1.np.ctrl.lb3.wr_ptr == 513)
    begin
        $write("lb3 :%h ",count);
        for(p=0; p<514; p=p+1)
        begin
            $write("%h",dut.genblk1.np.ctrl.lb3.buffer[p]);
            $write(" ");
        end
        count = count + 512;   
        $display("");

    end */
    
    //dis_count = dis_count + 1;
    //$display(dis_count);
    //if(dis_count > 100000 && dis_count < 150000)
      //  $display("curr_read_buff = %h : curr_write_buff = %h : pixel_rd_cnt = %d, out_data = %h, valid = %d ",dut.genblk1.np.ctrl.currRdLineBuff, dut.genblk1.np.ctrl.currWrLineBuff,dut.genblk1.np.ctrl.pixel_rd_count,dut.genblk1.np.ctrl.o_pixel_data,dut.genblk1.np.ctrl.o_pixel_data_valid,dut.genblk1.np.ctrl.totalPixelCounter);
    
     //$display(dut.genblk1.np.sharp.sh.o_convolved_data);
     //if(dut.genblk1.np.ctrl.totalPixelCounter < 1542)
     //if(dut.genblk1.np.ctrl.i_pixel_data_valid & !dut.genblk1.np.ctrl.rd_line_buffer)
     //begin
        //$write(dut.genblk1.np.ctrl.totalPixelCounter);
        //$write(":");
        //$write(dut.genblk1.np.ctrl.pixel_rd_count);
        //$write(dut.genblk1.np.ctrl.pixel_wr_count); 
        //$write("::");  
     //end       
 //end
 
endmodule


