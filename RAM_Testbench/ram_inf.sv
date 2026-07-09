interface ram_if(input logic clk);
  logic rst;
  logic w_enb = 0;
  logic [2:0] w_addr = 0;
  logic [2:0] rd_addr = 0;
  logic [7:0] data_in = 0;
  logic [7:0] data_out;

  clocking drv_cb @(posedge clk);
    default input #1step output #0;
    input  data_out;
    output w_enb, w_addr, rd_addr, data_in, rst;
  endclocking

  clocking mon_cb @(posedge clk);
    default input #1step;
    input w_enb, w_addr, rd_addr, data_in, data_out, rst;
  endclocking
endinterface
