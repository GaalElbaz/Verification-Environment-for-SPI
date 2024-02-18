`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class Name: scoreboard
//////////////////////////////////////////////////////////////////////////////////

class scoreboard;
    mailbox #(bit[11:0]) mbxds, mbxms;
    bit [11:0] ds;  // driver to scoreboard
    bit [11:0] ms; // monitor to scoreboard      
    event sconext;
    
    function new(mailbox #(bit [11:0]) mbxds, mailbox #(bit [11:0]) mbxms);
        this.mbxds = mbxds;
        this.mbxms = mbxms;
    endfunction
    
    task run();
        forever begin
            mbxds.get(ds);
            mbxms.get(ms);
            $display("[SCO] : DRV : %0d MON : %0d", ds, ms);
            
            if(ds == ms) begin
                $display("[SCO] : DATA MATCHED");
            end
            else begin
                $display("[SCO] : DATA MISMATCHED");
            end
            $display("-------------------------------------------");
            ->sconext;
        end
    endtask    
endclass