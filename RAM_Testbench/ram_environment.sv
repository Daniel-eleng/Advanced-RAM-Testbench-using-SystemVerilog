`include "ram_gen.sv"
`include "ram_driver.sv"
`include "ram_monitor.sv"
`include "ram_ref_model.sv"
`include "ram_scoreboard.sv"

class RAM_environment;
  RAM_generator gen;
  RAM_driver driver;
  RAM_monitor monitor;
  RAM_ref_model ref_model;
  RAM_scoreboard scoreboard;
  virtual ram_if inf;

  mailbox #(RAM_transaction) gen_to_drv_w_mbx;
  mailbox #(RAM_transaction) gen_to_drv_rd_mbx;

  mailbox #(RAM_transaction) mon_to_ref_w_mbx;
  mailbox #(RAM_transaction) mon_to_ref_rd_mbx;

  mailbox #(RAM_transaction) mon_to_scb_w_mbx;
  mailbox #(RAM_transaction) mon_to_scb_rd_mbx;

  mailbox #(RAM_transaction) ref_to_scb_mbx;

  function new(virtual ram_if inf, int unsigned w_count, int unsigned rd_count);
    this.inf = inf;
    gen_to_drv_w_mbx = new();
    gen_to_drv_rd_mbx = new();
    mon_to_ref_w_mbx = new();
    mon_to_ref_rd_mbx = new();
    mon_to_scb_w_mbx = new();
    mon_to_scb_rd_mbx = new();
    ref_to_scb_mbx = new();
    gen = new(gen_to_drv_w_mbx,gen_to_drv_rd_mbx,w_count,rd_count);
    driver = new(inf,gen_to_drv_w_mbx,gen_to_drv_rd_mbx);
    monitor = new(inf,mon_to_scb_w_mbx,mon_to_scb_rd_mbx,mon_to_ref_w_mbx,mon_to_ref_rd_mbx);
    ref_model = new(mon_to_ref_w_mbx,mon_to_ref_rd_mbx,ref_to_scb_mbx);
    scoreboard = new(mon_to_scb_rd_mbx,ref_to_scb_mbx);
  endfunction

  task run();
    fork
      gen.run();
      driver.run();
      monitor.run();
      ref_model.run();
      scoreboard.run();
      join_none
      endtask
    endclass
