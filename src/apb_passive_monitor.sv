class apb_passive_monitor extends uvm_monitor;

  `uvm_component_utils(apb_passive_monitor)
  uvm_analysis_port #(apb_sequence_item) item_passive_port;
  virtual apb_inf.PASSIVE_MONITOR vif;

  event passive_monitor_trigger ; // To trigger passive monitor from driver !!
  apb_sequence_item seq_item;

  function new(string name ="apb_passive_monitor",uvm_component parent =null);
    super.new(name,parent);
    seq_item = apb_sequence_item::type_id::create("seq_item");
    item_passive_port = new("item_passive_port",this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_inf)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF",{"virtual interface must be set for: ", get_full_name(), ".vif"});
    if(!uvm_config_db#(event)::get(this, "", "event2", passive_monitor_trigger))
      `uvm_fatal("NO_EVENT2",{"event2[passive_monitor_trigger] must be set for: ",get_full_name(),".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      @(passive_monitor_trigger);
      seq_item.PSLVERR = vif.apb_passive_monitor_cb.PSLVERR;
      seq_item.apb_read_data_out= vif.apb_passive_monitor_cb.apb_read_data_out;
      $display("passive monitor sending: @ %0t",$time);
      seq_item.print();
      $display("\n---------------------------------------------------------\n");
      item_passive_port.write(seq_item);
    end
  endtask


endclass
