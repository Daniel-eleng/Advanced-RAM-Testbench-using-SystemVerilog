`include "ram_trs.sv"

class RAM_ref_model;

    logic [7:0] RAM [0:7];
    mailbox #(RAM_transaction) ref_w_mbx;
    mailbox #(RAM_transaction) ref_rd_mbx;
    mailbox #(RAM_transaction) scoreboard_mbx;

    function new(mailbox #(RAM_transaction) ref_w_mbx,
                 mailbox #(RAM_transaction) ref_rd_mbx,
                 mailbox #(RAM_transaction) scoreboard_mbx);
        
        this.ref_w_mbx = ref_w_mbx;
        this.ref_rd_mbx = ref_rd_mbx;
        this.scoreboard_mbx = scoreboard_mbx;
        
        foreach(RAM[i]) begin
            RAM[i] = 0;
         end
    endfunction

    task run();
        RAM_transaction w_tr, rd_tr, ref_tr;
    fork
        forever begin
            ref_w_mbx.get(w_tr);
            if(w_tr.w_enb == 1) begin
                RAM[w_tr.w_addr] = w_tr.data_in;
            end
        end
        forever begin
            ref_rd_mbx.get(rd_tr);
            if(rd_tr.w_enb == 0) begin
                ref_tr = new();
                ref_tr.data_out = RAM[rd_tr.rd_addr];
                scoreboard_mbx.put(ref_tr);
            end
        end
    join_none
    endtask
endclass