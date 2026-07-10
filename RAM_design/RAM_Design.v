`timescale 1ns / 1ps

module ram_design(input clk, rst, w_enb,
                    input [2:0] w_addr,
                    input [2:0] rd_addr,
                    input [7:0] data_in,
                    output reg [7:0] data_out);
  reg [7:0] RAM [0:7];
  integer i;
  initial
  begin
    for(i = 0; i < 8; i = i + 1)
      RAM[i] = 8'd0;
  end

  always @(posedge clk or posedge rst)
  begin
    if(rst)
    begin
      data_out <= 8'd0;
    end
    else
    begin
      if(!w_enb)
      begin
        RAM[w_addr] <= data_in;
      end
      data_out <= RAM[rd_addr];
    end
  end
endmodule
