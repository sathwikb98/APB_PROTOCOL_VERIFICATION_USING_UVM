`uvm_analysis_imp_decl(_active_monitor)
`uvm_analysis_imp_decl(_passive_monitor)


class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)

    virtual apb_inf vif;

    uvm_analysis_imp_active_monitor #(apb_sequence_item, apb_scoreboard)  item_collected_export_active;
    uvm_analysis_imp_passive_monitor #(apb_sequence_item, apb_scoreboard) item_collected_export_passive;

    int match, mismatch;
    apb_sequence_item active_monitor_queue[$];
    apb_sequence_item passive_monitor_queue[$];

    reg[`DATA_WIDTH-1:0] slave0_mem[0:(2**(`ADDR_WIDTH-1)-1)];
    reg[`DATA_WIDTH-1:0] slave1_mem[0:(2**(`ADDR_WIDTH-1)-1)];

    function new (string name = "apb_scoreboard", uvm_component parent =null);
        super.new(name, parent);
    endfunction:new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(virtual apb_inf)::get(this,"","vif",vif));

        item_collected_export_active = new("item_collected_export_active", this);
        item_collected_export_passive = new("item_collected_export_passive", this);
    endfunction:build_phase

  virtual function void write_active_monitor(apb_sequence_item pack);
    $display("Scoreboard received from active monitor:: Packet");
    active_monitor_queue.push_back(pack);
  endfunction:write_active_monitor

  virtual function void write_passive_monitor(apb_sequence_item pack);
    $display("Scoreboard received from passive monitor:: Packet");
    passive_monitor_queue.push_back(pack);
  endfunction:write_passive_monitor


  virtual task run_phase(uvm_phase phase);
    apb_sequence_item actual_result;
    apb_sequence_item input_stimulus;
    //if(active_monitor_queue.size() > 0 && passive_monitor_queue.size() > 0) begin
      forever begin
        //$display("here , active_monitor_queue.size(): %0d , passive_monitor_queue.size(): %0d", active_monitor_queue.size() ,passive_monitor_queue.size());
        wait(active_monitor_queue.size() > 0 && passive_monitor_queue.size() > 0);
        //$display("here , active_monitor_queue.size(): %0d , passive_monitor_queue.size(): %0d", active_monitor_queue.size() ,passive_monitor_queue.size());
        actual_result = passive_monitor_queue.pop_front();

        input_stimulus = active_monitor_queue.pop_front();
        if(vif.apb_scb_cb.PRESETn)begin
        if(input_stimulus.transfer == 1'b1) begin
          if(!input_stimulus.READ_WRITE) begin : input_stimulus_write
            if(input_stimulus.apb_write_paddr[`ADDR_WIDTH-1] == 0) begin
                slave0_mem[input_stimulus.apb_write_paddr[`ADDR_WIDTH-2:0]] = input_stimulus.apb_write_data;
                $display("write to slave 0 ",$time);
          end
          else begin
              slave1_mem[input_stimulus.apb_write_paddr[`ADDR_WIDTH-2:0]] = input_stimulus.apb_write_data;
              $display("write to slave 1 ",$time);
          end

          end: input_stimulus_write
        else begin : else_input_stimulus_read

            if(input_stimulus.apb_read_paddr[`ADDR_WIDTH-1] == 0) begin

              if(slave0_mem[input_stimulus.apb_read_paddr[`ADDR_WIDTH-2:0]] === actual_result.apb_read_data_out) begin
            match++;
                `uvm_info(get_type_name(),$sformatf("-> For 0th slave selection ---------- MATCHED -------------\n EXPECTED OUTPUT : %0d \t ACTUAL OUTPUT : %0d",slave0_mem[input_stimulus.apb_read_paddr[`ADDR_WIDTH-2:0]],actual_result.apb_read_data_out),UVM_MEDIUM);
            end
            else begin
              mismatch++;
                `uvm_info(get_type_name(),$sformatf("-> For 0th slave selection ---------- MISMATCHED -------------\n EXPECTED OUTPUT : %0d \t ACTUAL OUTPUT : %0d",slave0_mem[input_stimulus.apb_read_paddr[`ADDR_WIDTH-2:0]],actual_result.apb_read_data_out),UVM_MEDIUM);
            end
            end

            else begin

              if(slave1_mem[input_stimulus.apb_read_paddr[7:0]] === actual_result.apb_read_data_out) begin
            match++;
                `uvm_info(get_type_name(),$sformatf("-> For 1st slave selection ---------- MATCHED -------------\n EXPECTED OUTPUT : %0d \t ACTUAL OUTPUT : %0d",slave1_mem[input_stimulus.apb_read_paddr[`ADDR_WIDTH-2:0]],actual_result.apb_read_data_out),UVM_MEDIUM);
            end

            else begin
              mismatch++;
                `uvm_info(get_type_name(),$sformatf("-> For 1st slave selection ---------- MISMATCHED -------------\n EXPECTED OUTPUT : %0d \t ACTUAL OUTPUT : %0d",slave1_mem[input_stimulus.apb_read_paddr[`ADDR_WIDTH-2:0]],actual_result.apb_read_data_out),UVM_MEDIUM);
            end

            end
          end
          $display("######################----------------------------------------------------------------------------------------------###########################");
        end
      end
      end
  endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("MATCH : %0d  ||  MISMATCH : %0d ",match,mismatch);
  endfunction

endclass:apb_scoreboard
