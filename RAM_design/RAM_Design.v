`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/12/2026 05:10:49 PM
// Design Name:
// Module Name: RAM_TB
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module RAM_TB(input clk, rst, w_enb,
                        input [2:0] w_addr, 
                        input [2:0] rd_addr,
                        input [7:0] data_in,
                        output reg [7:0] data_out);
  reg [7:0] RAM [0:7];

  always @(posedge clk or posedge rst)
  begin
    if(rst)
    begin
      data_out <= 8'd0;
    end
    else
    begin
      if(w_enb)
      begin
        RAM[w_addr] <= data_in;
      end
        data_out <= RAM[rd_addr];
    end
  end
endmodule
