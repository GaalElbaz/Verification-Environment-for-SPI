`timescale 1ns / 1ps
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "spi_if.sv"
//////////////////////////////////////////////////////////////////////////////////
// Class Name: environment
//////////////////////////////////////////////////////////////////////////////////

class environment;
    virtual spi_if sif;

    generator gen;
    driver drv;
    monitor mon;
    scoreboard sco;
    
    mailbox #(transaction) mbx;
    mailbox #(bit [11:0]) mbxds;
    mailbox #(bit [11:0]) mbxms;
    
    event sconext;
    
    function new(virtual spi_if sif);
        // initalizing mailbox
        mbx = new();
        mbxds = new();
        mbxms = new();
        // initalizing handelrs
        gen = new(mbx);
        drv = new(mbxds,mbx);
        mon = new(mbxms);
        sco = new(mbxds, mbxms);
        // initalizing interface
        this.sif = sif;
        drv.sif = this.sif;
        mon.sif = this.sif;
        // initializing events
        
        gen.sconext = sconext;
        sco.sconext = sconext;
        
    endfunction
    
    task pre_test();
        drv.reset();
    endtask
    
    task test();
        fork 
            gen.run();
            drv.run();
            mon.run();
            sco.run();
        join_any
    endtask
    
    task post_test();
        wait(gen.done.triggered);
        $finish();
    endtask
    
    task run();
        pre_test();
        test();
        post_test();
    endtask
endclass