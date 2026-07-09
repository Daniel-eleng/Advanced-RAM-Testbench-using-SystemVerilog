`include "ram_trs.sv"

class RAM_coverage;

    RAM_transaction tr;
    mailbox #(RAM_transaction) coverage_mbx;

    function new(mailbox #(RAM_transaction) coverage_mbx);
        this.coverage_mbx = coverage_mbx;
        ram_cg = new();
    endfunction

    covergroup ram_cg;
        cover_w_addr : coverpoint tr.w_addr{
            bins wr_addr[] = {[0:7]};
        }
        cover_rd_addr : coverpoint tr.rd_addr{
            bins rd_addr[] = {[0:7]};
        }
        cover_data_in : coverpoint tr.data_in{
            bins min = {8'h00};
            bins max = {8'hFF};
            bins mid = {[8'h01:8'hFE]};
        }
        cross_write_read : cross cover_w_addr, cover_rd_addr;
    endgroup

    task run();
        forever begin
            coverage_mbx.get(tr);
            ram_cg.sample();
        end
    endtask
endclass