class apb_test extends uvm_test;
  `uvm_component_utils(apb_test);
  apb_environment env;
  apb_sequence seq;

  function new(string name="apb_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_environment::type_id::create("env",this);
    seq = apb_sequence::type_id::create("seq",this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq.start(env.active_agent.sequencer);
    phase.drop_objection(this);
    `uvm_info(get_full_name,"End of test case: apb_test",UVM_LOW);
  endtask

endclass

class apb_write_read extends uvm_test;
  `uvm_component_utils(apb_write_read)
  apb_environment env;
  apb_sequence_write_read seq_1;

  function new(string name="apb_test_write_read",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_environment::type_id::create("env",this);
    seq_1 = apb_sequence_write_read::type_id::create("seq_1",this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq_1.start(env.active_agent.sequencer);
    phase.drop_objection(this);
    `uvm_info(get_full_name,"End of test case: apb_write_read",UVM_LOW);
  endtask
endclass

class apb_test_different_slave extends uvm_test;
  `uvm_component_utils(apb_test_different_slave)
  apb_environment env;
  apb_sequence_different_slave seq_2;

  function new(string name="apb_test_different_slave",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_environment::type_id::create("env",this);
    seq_2 = apb_sequence_different_slave::type_id::create("seq_2",this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq_2.start(env.active_agent.sequencer);
    phase.drop_objection(this);
    `uvm_info(get_full_name,"End of test case: apb_test_different_slave",UVM_LOW);
  endtask

endclass

class apb_test_sequence_transfer_t extends uvm_test;
  `uvm_component_utils(apb_test_sequence_transfer_t);
  apb_environment env;
  apb_sequence_transfer_t seq;

  function new(string name="apb_test_sequence_transfer_t",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_environment::type_id::create("env",this);
    seq = apb_sequence_transfer_t::type_id::create("seq",this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq.start(env.active_agent.sequencer);
    phase.drop_objection(this);
    `uvm_info(get_full_name,"End of test case: apb_test_sequence_transfer_t",UVM_LOW);
  endtask
endclass

class apb_continuous_write_read_test extends uvm_test;
  `uvm_component_utils(apb_continuous_write_read_test);
  apb_environment env;
  apb_continuous_write_read seq;

  function new(string name="apb_continuous_write_read_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_environment::type_id::create("env",this);
    seq = apb_continuous_write_read::type_id::create("seq",this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq.start(env.active_agent.sequencer);
    phase.drop_objection(this);
    `uvm_info(get_full_name,"End of test case: apb_continuous_write_read_test",UVM_LOW);
  endtask
endclass

class apb_error_condition_test extends uvm_test;
 `uvm_component_utils(apb_error_condition_test);
  apb_environment env;
  apb_error_condition seq;

  function new(string name="apb_error_condition_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_environment::type_id::create("env",this);
    seq = apb_error_condition::type_id::create("seq",this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq.start(env.active_agent.sequencer);
    phase.drop_objection(this);
    `uvm_info(get_full_name,"End of test case: apb_test_sequence_transfer_t",UVM_LOW);
  endtask

endclass

class apb_regression extends uvm_test;
  `uvm_component_utils(apb_regression)
  apb_environment env;
  apb_regression_seq seq;

  function new(string name="apb_regression",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_environment::type_id::create("env",this);
    seq = apb_regression_seq::type_id::create("seq_reg",this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq.start(env.active_agent.sequencer);
    phase.drop_objection(this);
    `uvm_info(get_full_name,"End of test case: apb_regression",UVM_LOW);
  endtask
endclass
