interface ram_if(input logic clk);
    logic rst;
    logic w_enb;
    logic [2:0] w_addr;
    logic [2:0] rd_addr;
    logic [7:0] data_in;
    logic [7:0] data_out;
endinterface
