`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class Name: driver
class driver;
  
  virtual spi_if sif;
  transaction tr;
  mailbox #(transaction) mbx;
  mailbox #(bit [11:0]) mbxds;
  
  bit [11:0] din;
 
  // Constructor
  function new(mailbox #(bit [11:0]) mbxds, mailbox #(transaction) mbx);
    this.mbx = mbx;
    this.mbxds = mbxds;
  endfunction
  
  // Task to reset the driver
  task reset();
     sif.rst <= 1'b1;
     sif.newd <= 1'b0;
     sif.din <= 1'b0;
    repeat(10) @(posedge sif.clk);
      sif.rst <= 1'b0;
    repeat(5) @(posedge sif.clk);
 
    $display("[DRV] : RESET DONE");
    $display("-----------------------------------------");
  endtask
  
  // Task to drive transactions
  task run();
    forever begin
      mbx.get(tr);
      sif.newd <= 1'b1;
      sif.din <= tr.din;
      mbxds.put(tr.din);
      @(posedge sif.sclk);
      sif.newd <= 1'b0;
      @(posedge sif.done);
      $display("[DRV] : DATA SENT TO SLAVE : %0d",tr.din);
      @(posedge sif.sclk);
    end
  endtask
  
endclass
