class apb_environment extends uvm_env;

  apb_agent active_agent, passive_agent;
  apb_subscriber subscrb;
  apb_scoreboard scb;

  `uvm_component_utils(apb_environment)

  function new(string name = "apb_environment", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_db#(uvm_active_passive_enum)::set(this,"active_agent","is_active",UVM_ACTIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"passive_agent","is_active",UVM_PASSIVE);

    active_agent = apb_agent::type_id::create("active_agent", this);
    passive_agent = apb_agent::type_id::create("passive_agent", this);
    scb = apb_scoreboard::type_id::create("scb", this);
    subscrb = apb_subscriber::type_id::create("subscrb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    active_agent.active_monitor.item_active_port.connect(scb.item_collected_export_active);
    passive_agent.passive_monitor.item_passive_port.connect(scb.item_collected_export_passive);
    active_agent.active_monitor.item_active_port.connect(subscrb.analysis_export); // using in-built analysis port /......
    passive_agent.passive_monitor.item_passive_port.connect(subscrb.passive_monitor_export);
   endfunction

endclass
