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

  constraint data_in_dist {
    data_in dist{
      8'h00 := 20,
      8'hFF := 20,
      [8'h01 : 8'hFE] :/ 60
    };
  }
endclass
