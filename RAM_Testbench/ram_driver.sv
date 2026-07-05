`include "ram_trs.sv"

class RAM_driver;
  virtual ram_if inf;
  mailbox #(RAM_transaction) w_mbx;
  mailbox #(RAM_transaction) rd_mbx;

  function  new(virtual ram_if inf,
                  mailbox #(RAM_transaction) w_mbx,
                  mailbox #(RAM_transaction) rd_mbx);

    this.inf = inf;
    this.w_mbx = w_mbx;
    this.rd_mbx = rd_mbx;

  endfunction

  task run();
    RAM_transaction tr;

    fork
      forever
      begin
        w_mbx.get(tr);
        @(inf.ram_cb);
        inf.ram_cb.w_enb <= tr.w_enb;
        inf.ram_cb.w_addr <= tr.w_addr;
        inf.ram_cb.rd_addr <= tr.rd_addr;
        inf.ram_cb.data_in <= tr.data_in;
      end

      forever
      begin
        rd_mbx.get(tr);
        @(inf.ram_cb);
        inf.ram_cb.w_enb <= 0;
        inf.ram_cb.w_addr <= tr.w_addr;
        inf.ram_cb.rd_addr <= tr.rd_addr;
        inf.ram_cb.data_in <= 0;
      end
      join_none

      endtask
    endclass
