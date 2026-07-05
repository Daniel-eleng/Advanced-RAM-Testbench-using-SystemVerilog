`include "ram_trs.sv"

class RAM_monitor;
  virtual ram_if inf;
  mailbox #(RAM_transaction) scoreboard_w_mbx;
  mailbox #(RAM_transaction) scoreboard_rd_mbx;
  mailbox #(RAM_transaction) reference_model_w_mbx;
  mailbox #(RAM_transaction) reference_model_rd_mbx;

  function new(virtual ram_if inf,
                 mailbox #(RAM_transaction) scoreboard_w_mbx,
                 mailbox #(RAM_transaction) scoreboard_rd_mbx,
                 mailbox #(RAM_transaction) reference_model_w_mbx,
                 mailbox #(RAM_transaction) reference_model_rd_mbx)

    this.inf = inf;
    this.scoreboard_rd_mbx = scoreboard_rd_mbx;
    this.scoreboard_w_mbx = scoreboard_w_mbx;
    this.reference_model_rd_mbx = reference_model_rd_mbx;
    this.reference_model_w_mbx = reference_model_w_mbx;

  endfunction

  task run();
    RAM_transaction tr;
    forever
    begin
      @(inf.ram_cb);
      if(inf.ram_cb.w_enb == 1'b1)
      begin
        tr = new();
        tr.w_enb = inf.ram_cb.w_enb;
        tr.w_addr = inf.ram_cb.w_addr;
        tr.data_in = inf.ram_cb.data_in;
        scoreboard_w_mbx.put(tr);
        reference_model_w_mbx.put(tr);
      end
      else if(inf.ram_cb.w_enb == 1'b0)
      begin
        tr = new();
        tr.w_enb = inf.ram_cb.w_enb;
        tr.rd_addr = inf.ram_cb.rd_addr;
        tr.data_out = inf.ram_cb.data_out;
        scoreboard_rd_mbx.put(tr);
        reference_model_rd_mbx.put(tr);
      end
    end
  endtask
endclass
