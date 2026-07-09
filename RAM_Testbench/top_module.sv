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
    inf.drv_cb.rst <= 1;
    @(inf.drv_cb);
    inf.drv_cb.rst <= 0;
  end

  initial
  begin
    $display("====================================================");
    $display(" RAM VERIFICATION ENVIRONMENT — SIMULATION START");
    $display("====================================================");

    env = new(inf, 80);
    env.run();
    #1000;

    env.scoreboard.report();
    $display(" Functional coverage: %0.2f%%", env.coverage.ram_cg.get_coverage());

    $display("====================================================");
    $display(" SIMULATION END");
    $display("====================================================");
    $finish;
  end
endmodule
