`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class Name: generator
//////////////////////////////////////////////////////////////////////////////////

class generator;
  
  transaction tr;
  mailbox #(transaction) mbx;
  event done;
  int count = 0;
  event sconext;      // scoreboard completed comparing the recieved response with the expected data
  
  // Constructor
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
    tr = new();
  endfunction
  
  // Task to generate transactions
  task run();
    repeat(count) begin
      assert(tr.randomize) else $error("[GEN] :Randomization Failed");
      mbx.put(tr.copy);
      $display("[GEN] : din : %0d", tr.din);
      @(sconext);
    end
    -> done;
  endtask
  
endclass
 