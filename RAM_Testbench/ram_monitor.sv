`include "ram_trs.sv"

class RAM_monitor;
  virtual ram_if inf;
  mailbox #(RAM_transaction) scoreboard_mbx;
  mailbox #(RAM_transaction) reference_model_mbx;
  mailbox #(RAM_transaction) coverage_mbx;

  bit pending_rd;
  logic [2:0] pending_rd_addr;

  function new(virtual ram_if inf,
                 mailbox #(RAM_transaction) scoreboard_mbx,
                 mailbox #(RAM_transaction) reference_model_mbx,
                 mailbox #(RAM_transaction) coverage_mbx);

    this.inf = inf;
    this.scoreboard_mbx = scoreboard_mbx;
    this.reference_model_mbx = reference_model_mbx;
    this.coverage_mbx = coverage_mbx;

  endfunction

   task run();
    RAM_transaction tr;
    forever begin
      @(inf.ram_cb);
      if(inf.rst == 1) begin
        pending_rd = 0;
        continue;
      end

      if(pending_rd) begin
        tr = new();
        tr.w_enb = 0;
        tr.rd_addr = pending_rd_addr;
        tr.data_out = inf.ram_cb.data_out;
        scoreboard_mbx.put(tr);
        reference_model_mbx.put(tr);
        coverage_mbx.put(tr);
        pending_rd = 0;
      end

      if(inf.ram_cb.w_enb == 1'b1) begin
        tr = new();
        tr.w_enb = 1;
        tr.w_addr = inf.ram_cb.w_addr;
        tr.data_in = inf.ram_cb.data_in;
        reference_model_mbx.put(tr);
        coverage_mbx.put(tr);
      end
      else begin
        pending_rd = 1;
        pending_rd_addr = inf.ram_cb.rd_addr;
      end
    end
  endtask
endclass
