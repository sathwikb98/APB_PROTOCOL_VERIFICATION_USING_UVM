interface apb_inf(input logic PCLK, PRESETn);
  logic transfer;
  logic READ_WRITE;
  logic [`ADDR_WIDTH-1:0] apb_write_paddr;
  logic [`DATA_WIDTH-1:0] apb_write_data;
  logic [`ADDR_WIDTH-1:0] apb_read_paddr;
  logic [`DATA_WIDTH-1:0] apb_read_data_out;
  logic PSLVERR;

clocking apb_driver_cb @(posedge PCLK);
  default input #0 output #0;
  output transfer;
  output READ_WRITE;
  output apb_write_paddr;
  output apb_read_paddr;
  output apb_write_data;
  input PSLVERR;
  input apb_read_data_out;
  input PRESETn;
endclocking

clocking apb_active_monitor_cb @(posedge PCLK);
  default input #0 output #0;
  input transfer;
  input READ_WRITE;
  input apb_write_paddr;
  input apb_write_data;
  input apb_read_paddr;
  input PRESETn;
endclocking

clocking apb_passive_monitor_cb @(posedge PCLK);
  default input #0 output #0;
  input PSLVERR;
  input apb_read_data_out;
  input PRESETn;
endclocking

clocking apb_scb_cb @(posedge PCLK);
  default input #0 output #0;
  input PRESETn;
endclocking

modport scb(clocking apb_scb_cb);
modport DRIVER(clocking apb_driver_cb);

modport ACTIVE_MONITOR(clocking apb_active_monitor_cb);
modport PASSIVE_MONITOR(clocking apb_passive_monitor_cb);

endinterface
