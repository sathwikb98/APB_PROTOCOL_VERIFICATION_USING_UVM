`uvm_analysis_imp_decl(_pas_mon)

class apb_subscriber extends uvm_subscriber#(apb_sequence_item);

  `uvm_component_utils(apb_subscriber)
  // one analysis port is in-built used for active monitor..........
  uvm_analysis_imp_pas_mon#(apb_sequence_item,apb_subscriber) passive_monitor_export;

  apb_sequence_item act_item;
  apb_sequence_item pas_item;

  real active_cov,passive_cov;

  covergroup act_mon_cov;
    SLAVE_SELECT : coverpoint act_item.apb_write_paddr[8]{
                                                  bins slave1 = {1};
                                                  bins slave2 = {0};
                                                }
    WRITE_READ_CHECK:coverpoint act_item.READ_WRITE {
                                             bins write_transfer = {1};
                                             bins read_trnasfer = {0};
                                           }
    WRITE_ADDRESS_CHECK : coverpoint act_item.apb_write_paddr{
                                                     bins write_address[]={[0:(2**8)-1]};
                                                    }
    READ_ADDRESS_CHECK : coverpoint act_item.apb_read_paddr {
                                                     bins read_address[]={[0:(2**8)-1]};
                                                   }
    WRITE_DATA_CHECK : coverpoint act_item.apb_write_paddr {
                                                    bins write_data[]={[0:(2**8)-1]};
                                                  }
  endgroup

  covergroup pas_mon_cov;
    READ_DATA_CHECK : coverpoint pas_item.apb_read_data_out {
                                                bins read_data[]={[0:(2**8)-1]};
                                               }
    SLV_ERROR_CHECK : coverpoint pas_item.PSLVERR {
                                           bins high = {1};
                                           bins low = {0};
                                         }
  endgroup

  function new(string name="apb_subscriber",uvm_component parent=null);
      super.new(name,parent);
      act_item=new("active_monitor");
      pas_item=new("passive_monitor");

      act_mon_cov=new();
      pas_mon_cov=new();

      passive_monitor_export = new("passive_monitor_export",this);
  endfunction

  function void write(apb_sequence_item t);
    act_item = t;
    act_mon_cov.sample();
  endfunction

  function void write_pas_mon(apb_sequence_item t);
    pas_item = t;
    pas_mon_cov.sample();
  endfunction

  function void extract_phase(uvm_phase phase);
  super.extract_phase(phase);
  active_cov = act_mon_cov.get_coverage();
  passive_cov = pas_mon_cov.get_coverage();
endfunction

  function void report_phase(uvm_phase phase);
   super.report_phase(phase);
    `uvm_info(get_type_name, $sformatf("[INPUT] Coverage ------> %0.2f%%,", active_cov), UVM_MEDIUM);
    `uvm_info(get_type_name, $sformatf("[OUTPUT] Coverage ------> %0.2f%%", passive_cov), UVM_MEDIUM);
  endfunction

endclass
