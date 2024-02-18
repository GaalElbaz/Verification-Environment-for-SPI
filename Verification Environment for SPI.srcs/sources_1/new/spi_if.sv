`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: spi_interface
//////////////////////////////////////////////////////////////////////////////////


interface spi_if;
    logic clk;
    logic rst;
    logic newd; // new data
    logic [11:0] din;
    logic sclk;
    logic cs;   // select line
    logic mosi; // master out slave in
    logic [11:0] dout;
    logic done;
    
    modport MASTER (
        input clk,rst,newd,din,
        output sclk,cs,mosi
    );
    
    modport SLAVE (
        input sclk, cs, mosi,
        output dout, done
    );
    
endinterface

