`include "ram_trs.sv"

class RAM_scoreboard;

  mailbox #(RAM_transaction) monitor_rd_mbx;
  mailbox #(RAM_transaction) ref_mbx;

  function new(mailbox #(RAM_transaction) monitor_rd_mbx,
                 mailbox #(RAM_transaction) ref_mbx);

    this.monitor_rd_mbx = monitor_rd_mbx;
    this.ref_mbx = ref_mbx;

  endfunction

  task run();
    RAM_transaction monitor_rd_tr, ref_tr;
    forever
    begin
      monitor_rd_mbx.get(monitor_rd_tr);
      ref_mbx.get(ref_tr);

      if(monitor_rd_tr.data_out == ref_tr.data_out)
      begin
        $display("Scoreboard pass: Adress : %0d | Real model : %0h = Golden Model : %0h",monitor_rd_tr.rd_addr,monitor_rd_tr.data_out,ref_tr.data_out);
      end

      else
      begin
        $display("Scoreboard fail : Adress : %0d | Real model : %0h != Golden Model : %0h",monitor_rd_tr.rd_addr,monitor_rd_tr.data_out,ref_tr.data_out);
      end
    end
  endtask
endclass
