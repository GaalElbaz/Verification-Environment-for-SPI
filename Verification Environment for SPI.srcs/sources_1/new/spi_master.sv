`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: spi
//////////////////////////////////////////////////////////////////////////////////
module spi_master(spi_if.MASTER sif);
  
  typedef enum bit{idle = 1'b0, send = 1'b1} state_type;
  state_type state = idle;
  
  int sclk_count = 0;
  int bit_count = 0;
    
  // generation of sclk
  // sclk is usually slower than the input clock so we will generate a slow clock
 always@(posedge sif.clk)
  begin
    if(sif.rst == 1'b1) begin
      sclk_count <= 0;
      sif.sclk <= 1'b0;
    end
    else begin 
      if(sclk_count < 10 )   /// fclk / 20
          sclk_count <= sclk_count + 1;
      else
          begin
          sclk_count <= 0;
          sif.sclk <= ~sif.sclk;
          end
    end
  end
  
  //////////////////state machine
    reg [11:0] temp;
    
  always@(posedge sif.sclk)
  begin
    if(sif.rst == 1'b1) begin
      sif.cs <= 1'b1; 
      sif.mosi <= 1'b0;
    end
    else begin
     case(state)
         idle:
             begin
               if(sif.newd == 1'b1) begin       // when new data is high -> start sending
                 state <= send;                 // go to send state
                 temp <= sif.din;           // serialize data
                 sif.cs <= 1'b0;                // active low when enable 
               end
               else begin
                 state <= idle;
                 temp <= 0;
               end
             end
       
       
       send : begin
         if(bit_count <= 11) begin
           sif.mosi <= temp[bit_count]; /////sending lsb first        
           bit_count <= bit_count + 1;
         end
         else
             begin
               bit_count <= 0;      // for next transmission
               state <= idle;       // go back to idle state
               sif.cs <= 1'b1;      // active high when disable
               sif.mosi <= 1'b0;
               
             end
       end
       
                
      default : state <= idle; 
       
   endcase
  end 
 end
  
endmodule