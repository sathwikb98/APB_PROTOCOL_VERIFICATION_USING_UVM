interface apb_assertion(
 input logic PCLK,
 input logic PRESETn,
 input logic transfer,
 input logic READ_WRITE,
 input logic [`ADDR_WIDTH-1:0] apb_write_paddr,
 input logic [`DATA_WIDTH-1:0] apb_write_data,
 input logic [`ADDR_WIDTH-1:0] apb_read_paddr,
 input logic [`DATA_WIDTH-1:0] apb_read_data_out,
 input logic PSLVERR
);
//   int count;
//   bit start_process;
//   always@(posedge PCLK) begin

//     if(count >= 2) begin
//         start_process = 1;
//       end
//       else begin
//         start_process = 0;
//       end
//       count++;
//     //$display("time : %0t || count : %0d",$time,count);
//   end


  // ...................... ASSERTIONS .......................

      property reset_valid_check;
        @(posedge PCLK) !$isunknown(PRESETn);
      endproperty

      assert property(reset_valid_check)
        else $error("PRESETn is unknown",$time);

        property transfer_valid_check;
          @(posedge PCLK) disable iff(!PRESETn) !$isunknown(transfer);
      endproperty

        assert property(transfer_valid_check)
          else $error("transfer signal is unknown ",$time);

      property read_write_valid_check;
        @(posedge PCLK) disable iff(!PRESETn) !$isunknown(READ_WRITE);
      endproperty

      // -------------------------- 2. -----------------------------------------
      property transfer_assert;
    @(posedge PCLK) disable iff (!PRESETn)
          $rose(transfer) |=> ##[2:3] ($stable(apb_write_paddr) && $stable(READ_WRITE) && $stable(apb_read_paddr));
    endproperty
      assert property(transfer_assert)
      else $error("write or read address or read_write changed during the transfer");

      property transfer_deassert;
      @(posedge PCLK) disable iff (!PRESETn)
      (!transfer) |=> ($stable(PSLVERR) && $stable(apb_read_data_out));
      endproperty

      assert property(transfer_deassert)
        else $error("outputs are not stable when there is no transfer");

      property slave_selected_with_validity;
        @(posedge PCLK) disable iff(!PRESETn) ( !$isunknown(apb_write_paddr[`ADDR_WIDTH-1]) & !$isunknown(apb_read_paddr[`ADDR_WIDTH-1]) ) |-> (!$isunknown({apb_write_paddr, apb_read_paddr}))
      endproperty

      assert property (slave_selected_with_validity)
        else $error("slave selected without valid write & read address !!");

      property READ_WRITE_write_data_valid_check;
        @(posedge PCLK) disable iff(!PRESETn)
          (!READ_WRITE) |-> (!$isunknown(apb_write_data) && !$isunknown(apb_write_paddr)) ; // write op
      endproperty

      assert property (READ_WRITE_write_data_valid_check)
        else $error("WRITE operation with in-valid write_data !!");

      property READ_WRITE_read_data_valid_check;
        @(posedge PCLK) disable iff(!PRESETn)
          (READ_WRITE) |-> ( !$isunknown(apb_read_paddr)) ; // read op
      endproperty

      assert property (READ_WRITE_read_data_valid_check)
        else $error("READ operation with in-valid READ_ADDRESS!!");

      property p5;
        @(posedge PCLK) disable iff (PRESETn)
        (!PRESETn && READ_WRITE==1) |=> (apb_read_data_out==0 && PSLVERR==0);
      endproperty

endinterface
