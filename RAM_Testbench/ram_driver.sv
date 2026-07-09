`include "ram_trs.sv"

class RAM_driver;
  virtual ram_if inf;
  mailbox #(RAM_transaction) driver_mbx;

  function  new(virtual ram_if inf,
                  mailbox #(RAM_transaction) driver_mbx);

    this.inf = inf;
    this.driver_mbx = driver_mbx;

  endfunction

  task run();
    RAM_transaction tr;
    wait(inf.rst == 0);
    forever
    begin
      driver_mbx.get(tr);
      @(inf.ram_cb);
      inf.ram_cb.w_enb <= tr.w_enb;
      inf.ram_cb.w_addr <= tr.w_addr;
      inf.ram_cb.rd_addr <= tr.rd_addr;
      inf.ram_cb.data_in <= tr.data_in;

      if(tr.w_enb)
        $display("[%0t] DRIVER | WRITE | w_addr=%0d | data_in=0x%0h",
                 $time, tr.w_addr, tr.data_in);
      else
        $display("[%0t] DRIVER | READ  | rd_addr=%0d",
                 $time, tr.rd_addr);
    end
  endtask
endclass
