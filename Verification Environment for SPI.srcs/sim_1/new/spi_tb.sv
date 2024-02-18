`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: spi_tb
//////////////////////////////////////////////////////////////////////////////////


module spi_tb;
    // declaring the interface
    spi_if sif();
     // instaniting the dut
    spi_top DUT(sif);
    
    // creating clock
    initial begin
        sif.clk <= 1'b0;
    end
    
    always #10 sif.clk <= ~sif.clk;
    
    // running tests
    environment env;
    initial begin
        env = new(sif);
        env.gen.count = 4;
        env.run();
    end
    
    
endmodule
