`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: spi_slave
//////////////////////////////////////////////////////////////////////////////////
module spi_slave(spi_if.SLAVE sif);
    typedef enum bit {idle = 1'b0, read = 1'b1} state_type;
    state_type state = idle;
    
    reg [11:0] temp = 0;
    int bit_index = 0;
    
    always_ff @(posedge sif.sclk) begin
        case(state)
            idle: begin
                sif.done <= 1'b0;
                if(sif.cs == 1'b0) begin    // data is ready when cs is low
                    state <= read;
                end
                else begin
                    state <= idle;
                end
            end // end of idle state
            read: begin
                if(bit_index <= 11) begin
                    bit_index <= bit_index + 1;
                    temp <= {sif.mosi, temp[11:1]}; // shifting MSB each itertaion                    
                    bit_index <= bit_index + 1;                 
                end
                else begin
                    bit_index <= 0;
                    sif.done <= 1'b1;
                    state <= idle;
                end
            end // end of read state
        endcase
    end
    
    assign sif.dout = temp; //connect output bus 

endmodule