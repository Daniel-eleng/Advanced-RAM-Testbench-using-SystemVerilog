interface ram_if(input logic clk);
  logic rst;
  logic w_enb;
  logic [2:0] w_addr;
  logic [2:0] rd_addr;
  logic [7:0] data_in;
  logic [7:0] data_out;

  clocking ram_cb(@posedge clk);
    default input #1step output #0;

    input data_out;
    output w_enb, w_addr, rd_addr, data_in;
  endclocking
endinterface
