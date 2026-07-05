class RAM_transaction;
  rand logic w_enb;
  rand logic [2:0] w_addr;
  rand logic [2:0] rd_addr;
  rand logic [7:0] data_in;
  logic [7:0] data_out;

  function new();
    w_enb = 0;
    w_addr = 0;
    rd_addr = 0;
    data_in = 0;
  endfunction

  function print();
    $display("At time %0t the values are: w_enb = %0h | w_addr = %0h | rd_addr = %0h | data_in = %0h | data_out = %0h",$time,w_enb,w_addr,rd_addr,data_in,data_out);

  endfunction
endclass
