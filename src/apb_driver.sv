class apb_driver extends uvm_driver #(apb_sequence_item);

  virtual apb_inf.DRIVER vif;

  int delay;
  event active_monitor_trigger,passive_monitor_trigger;
  logic prev_transfer /*, prev_slave_select*/ ;
  apb_sequence_item req;

  `uvm_component_utils(apb_driver)
  //uvm_analysis_port #(apb_sequence_item) item_collect_port;

function new (string name ="apb_driver", uvm_component parent =null);
  super.new(name, parent);
  req = apb_sequence_item::type_id::create("req");
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual apb_inf.DRIVER)::get(this, "", "vif", vif))
`uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  if(!uvm_config_db#(event)::get(this, "", "event1", active_monitor_trigger))
    `uvm_fatal("NO_EVENT1",{"event1 must be set for: ",get_full_name(),".vif"});
  if(!uvm_config_db#(event)::get(this, "", "event2", passive_monitor_trigger))
    `uvm_fatal("NO_EVENT2",{"event2 must be set for: ",get_full_name(),".vif"});

endfunction

task drive();
  vif.apb_driver_cb.transfer <= req.transfer;
  vif.apb_driver_cb.READ_WRITE <= req.READ_WRITE;
  vif.apb_driver_cb.apb_write_paddr <= req.apb_write_paddr;
  vif.apb_driver_cb.apb_write_data <= req.apb_write_data;
  vif.apb_driver_cb.apb_read_paddr <= req.apb_read_paddr;
  $display("driving",$time);
  ->active_monitor_trigger;
  @(vif.apb_driver_cb );        
  
  if(req.transfer && vif.apb_driver_cb.PRESETn)begin
    delay = (req.transfer === prev_transfer) ? 2 : 3;
    //delay = (req.transfer === prev_transfer && (req.apb_read_paddr[8] || req.apb_write_paddr[8]) === prev_slave_select) ? 2 : 3;
  end
  else begin
    delay = 1;
  end

  prev_transfer = (req.transfer && vif.apb_driver_cb.PRESETn) ? req.transfer : prev_transfer;
  //prev_slave_select = (req.apb_read_paddr[8] || req.apb_write_paddr[8] )? 1 : 0;
  repeat(delay) @(vif.apb_driver_cb);
  $display("%0d",delay);
  ->passive_monitor_trigger;
endtask

  virtual task run_phase(uvm_phase phase);
    @(posedge vif.apb_driver_cb); //delay to check for PRESETn!
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask
  
endclass
