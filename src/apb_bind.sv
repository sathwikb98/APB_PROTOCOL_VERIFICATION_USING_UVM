bind apb_inf apb_assertion apb_inf_assertion_inst (
  .PCLK(PCLK),
  .PRESETn(PRESETn),
  .transfer(transfer),
  .READ_WRITE(READ_WRITE),
  .apb_write_paddr(apb_write_paddr),
  .apb_write_data(apb_write_data),
  .apb_read_paddr(apb_read_paddr),
  .apb_read_data_out(apb_read_data_out),
  .PSLVERR(PSLVERR)
);
