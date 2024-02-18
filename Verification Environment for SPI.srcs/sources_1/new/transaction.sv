`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class Name: transaction
//////////////////////////////////////////////////////////////////////////////////
class transaction;
  
  rand bit [11:0] din;
  bit newd;
  bit [11:0] dout;
  
  // Transaction copy function
  function transaction copy();
    copy = new();
    copy.newd = this.newd;
    copy.din = this.din;
    copy.dout = this.dout;
  endfunction
  
endclass
 
