`include "ram_trs.sv"

class RAM_scoreboard;

  mailbox #(RAM_transaction) monitor_rd_mbx;
  mailbox #(RAM_transaction) ref_mbx;

  int unsigned pass_count;
  int unsigned fail_count;

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
        pass_count++;
        $display("[%0t] SCOREBOARD PASS | rd_addr=%0d | DUT=0x%0h | REF=0x%0h", 
                  $time, monitor_rd_tr.rd_addr, monitor_rd_tr.data_out, ref_tr.data_out);
      end

      else
      begin
        fail_count++;
        $display("[%0t] SCOREBOARD FAIL | rd_addr=%0d | DUT=0x%0h | REF=0x%0h",
                  $time, monitor_rd_tr.rd_addr, monitor_rd_tr.data_out, ref_tr.data_out);
      end
    end
  endtask

  function void report();
    int unsigned total;
    real pass_rate;
    total = pass_count + fail_count;
    pass_rate = (total == 0) ? 0.0 : (100.0 * pass_count / total);

    $display("--------------------------------------------------");
    $display(" SCOREBOARD REPORT");
    $display("--------------------------------------------------");
    $display(" Total checks : %0d", total);
    $display(" Passed       : %0d", pass_count);
    $display(" Failed       : %0d", fail_count);
    $display(" Pass rate    : %0.2f%%", pass_rate);
    $display("--------------------------------------------------");
    if(fail_count == 0)
      $display(" RESULT: ALL CHECKS PASSED");
    else
      $display(" RESULT: %0d CHECK(S) FAILED", fail_count);
    $display("--------------------------------------------------");
  endfunction
endclass
