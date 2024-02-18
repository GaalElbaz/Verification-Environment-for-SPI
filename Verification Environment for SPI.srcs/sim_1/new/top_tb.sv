`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: top_tb
//
//////////////////////////////////////////////////////////////////////////////////


module top_tb();

// creating the interface handler
    spi_if sif();
// module instaniation
    spi_top SPI_PROTOCOL(sif);
    
    initial begin
        sif.clk = 0;
        sif.newd = 0;
        sif.din = 0;
        sif.rst = 0;
    end
    always #10 sif.clk = ~sif.clk;
    
    initial begin
        sif.rst = 1'b1;
        repeat(5) @(posedge sif.clk);
        sif.rst = 1'b0;
        
        for(int i = 0; i < 5; i++) begin
            sif.newd = 1'b1;
            sif.din = $urandom;
            $display("urandom is %d", sif.din);
            @(posedge sif.sclk)
            sif.newd = 1'b0;
            @(posedge sif.done);
        end
        $finish();
    end

endmodule
