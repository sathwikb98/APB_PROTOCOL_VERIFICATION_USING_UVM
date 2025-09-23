class apb_sequence_item extends uvm_sequence_item;
 
  rand logic  transfer;
  rand logic READ_WRITE;
  rand logic [`ADDR_WIDTH-1:0]apb_write_paddr;
  rand logic [`DATA_WIDTH-1:0]apb_write_data;
  rand logic [`ADDR_WIDTH-1:0]apb_read_paddr;
  logic [`DATA_WIDTH-1:0]apb_read_data_out;
  logic PSLVERR;

  `uvm_object_utils_begin(apb_sequence_item)
 
  `uvm_field_int(transfer,UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(READ_WRITE,UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(apb_write_paddr,UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(apb_write_data,UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(apb_read_paddr,UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(apb_read_data_out,UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(PSLVERR,UVM_ALL_ON | UVM_DEC)
  `uvm_object_utils_end
 
  function new(string name = "apb_sequence_item");
    super.new(name);
  endfunction
 
  constraint write_read_same_location { solve apb_write_paddr[`ADDR_WIDTH-2:0] before apb_read_paddr[`ADDR_WIDTH-2:0]; apb_write_paddr[`ADDR_WIDTH-2:0] == apb_read_paddr[`ADDR_WIDTH-2:0]; }
  
  constraint Transfer_READ_WRITE_Dist { soft transfer == 1;  /*apb_write_paddr[8] == 1; apb_read_paddr[8] == 1;*/
                                       solve apb_write_paddr[`ADDR_WIDTH-1] before apb_read_paddr[`ADDR_WIDTH-1];
                                       apb_write_paddr[`ADDR_WIDTH-1] == apb_read_paddr[`ADDR_WIDTH-1];
                             		      }
  
endclass
