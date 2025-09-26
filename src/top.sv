`include "uvm_macros.svh"
`include "apb_pkg.sv"
`include "apb_inf.sv"
`include "apb_bind.sv"
`include "apb_assertion.sv"
`include "apbtop.v"

module top;
  bit PCLK;
  logic PRESETn;
  always #5 PCLK = ~PCLK;
  event active_monitor_trigger, passive_monitor_trigger;

  import apb_pkg::*;
  import uvm_pkg::*;

  initial begin
    PRESETn = 1'b0;
    #10 PRESETn = 1'b1;
  end

  apb_inf intf(PCLK,PRESETn);

  APB_Protocol dut (.PRESETn(PRESETn),.PCLK(PCLK),.transfer(intf.transfer),.READ_WRITE(intf.READ_WRITE),.apb_write_paddr(intf.apb_write_paddr),.apb_write_data(intf.apb_write_data),.apb_read_paddr(intf.apb_read_paddr),.apb_read_data_out(intf.apb_read_data_out), .PSLVERR(intf.PSLVERR));

  initial begin
    // set interface from top
    uvm_config_db#(virtual apb_inf)::set(uvm_root::get(),"*","vif",intf);

    // set events from top
    uvm_config_db#(event)::set(uvm_root::get(),"*","event1",active_monitor_trigger);
    uvm_config_db#(event)::set(uvm_root::get(),"*","event2",passive_monitor_trigger);

    $dumpfile("dump.vcd");
    $dumpvars;
  end
  initial begin
    //run_test("apb_error_condition_test");
    //run_test("apb_test");
    //run_test("apb_write_read");
    //run_test("apb_test_different_slave");
    //run_test("apb_test_sequence_transfer_t");
    //run_test("apb_continuous_write_read_test");
    run_test("apb_regression");
    #100 $finish;
  end
endmodule
