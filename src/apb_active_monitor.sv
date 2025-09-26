class apb_active_monitor extends uvm_monitor;

  `uvm_component_utils(apb_active_monitor)
  uvm_analysis_port #(apb_sequence_item) item_active_port;
  virtual apb_inf.ACTIVE_MONITOR vif;

  event active_monitor_trigger; // event to trigger active monitor from driver !
  apb_sequence_item seq_item;

  function new(string name = "apb_active_monitor",uvm_component parent = null);
    super.new(name,parent);
    seq_item = apb_sequence_item::type_id::create("seq_item");
    item_active_port = new("item_active_port",this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_inf)::get(this,"","vif",vif))
           `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    if(!uvm_config_db#(event)::get(this, "", "event1", active_monitor_trigger))
      `uvm_fatal("NO_EVENT1",{"event1[active_monitor_trigger] must be set for: ",get_full_name(),".vif"});

  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      @(active_monitor_trigger);
      @(vif.apb_active_monitor_cb);
      seq_item.transfer = vif.apb_active_monitor_cb.transfer;
      seq_item.READ_WRITE = vif.apb_active_monitor_cb.READ_WRITE;
      seq_item.apb_write_paddr = vif.apb_active_monitor_cb.apb_write_paddr;
      seq_item.apb_write_data = vif.apb_active_monitor_cb.apb_write_data;
      seq_item.apb_read_paddr = vif.apb_active_monitor_cb.apb_read_paddr;
      $display("active monitor sending : @ %0t",$time);
      seq_item.print();
      $display("\n---------------------------------------------------------\n");
      item_active_port.write(seq_item);
    end
  endtask


endclass
