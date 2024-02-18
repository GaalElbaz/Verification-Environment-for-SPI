`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class Name: monitor
//////////////////////////////////////////////////////////////////////////////////

class monitor;
  transaction tr;
  mailbox #(bit [11:0]) mbx;
 
  virtual spi_if sif;
 
  // Constructor
  function new(mailbox #(bit [11:0]) mbx);
    this.mbx = mbx;
  endfunction
 
  // Task to monitor the bus
  task run();
    tr = new();
    forever begin
      @(posedge sif.sclk);
      @(posedge sif.done);
      tr.dout = sif.dout;
      @(posedge sif.sclk);
      $display("[MON] : DATA SENT : %0d", tr.dout);
      mbx.put(tr.dout);
    end
  endtask
 
endclass