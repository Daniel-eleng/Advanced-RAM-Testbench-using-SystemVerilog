`include "ram_design.v"
`include "ram_inf.sv"
`include "ram_environment.sv"

module top_module;

  bit clk;
  initial
    clk = 0;
  always #5 clk = ~clk;

  ram_if inf(clk);

  ram_design DUT(.clk(inf.clk),
                 .rst(inf.rst),
                 .w_enb(inf.w_enb),
                 .w_addr(inf.w_addr),
                 .rd_addr(inf.rd_addr),
                 .data_in(inf.data_in),
                 .data_out(inf.data_out));

  RAM_environment env;

  initial
  begin
    env = new(inf, 40, 40);
    env.run();
    #1000;
    $finish;
  end
endmodule
