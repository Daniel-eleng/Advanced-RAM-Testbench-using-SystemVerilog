`include "ram_gen.sv"
`include "ram_driver.sv"
`include "ram_monitor.sv"
`include "ram_ref_model.sv"
`include "ram_scoreboard.sv"
`include "ram_coverage.sv"

class RAM_environment;
  RAM_generator gen;
  RAM_driver driver;
  RAM_monitor monitor;
  RAM_ref_model ref_model;
  RAM_scoreboard scoreboard;
  virtual ram_if inf;
  RAM_coverage coverage;


  mailbox #(RAM_transaction) gen_to_drv_mbx;

  mailbox #(RAM_transaction) mon_to_ref_mbx;

  mailbox #(RAM_transaction) mon_to_scb_mbx;

  mailbox #(RAM_transaction) mon_to_cov_mbx;

  mailbox #(RAM_transaction) ref_to_scb_mbx;

  function new(virtual ram_if inf, int unsigned counter);
    this.inf = inf;


    gen_to_drv_mbx = new();
    mon_to_ref_mbx = new();
    mon_to_scb_mbx = new();
    mon_to_cov_mbx = new();
    ref_to_scb_mbx = new();


    gen = new(gen_to_drv_mbx,counter);
    driver = new(inf,gen_to_drv_mbx);
    monitor = new(inf,mon_to_scb_mbx,
                  mon_to_ref_mbx,mon_to_cov_mbx);
    ref_model = new(mon_to_ref_mbx,ref_to_scb_mbx);
    scoreboard = new(mon_to_scb_mbx,ref_to_scb_mbx);
    coverage = new(mon_to_cov_mbx);

  endfunction

  task run();
    fork
      gen.run();
      driver.run();
      monitor.run();
      ref_model.run();
      scoreboard.run();
      coverage.run();
      join_none
      endtask
    endclass
