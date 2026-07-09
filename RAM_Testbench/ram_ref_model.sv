class RAM_ref_model;

    logic [7:0] RAM [0:7];
    mailbox #(RAM_transaction) ref_mbx;
    mailbox #(RAM_transaction) scoreboard_mbx;

    function new(mailbox #(RAM_transaction) ref_mbx,
                 mailbox #(RAM_transaction) scoreboard_mbx);
        
        this.ref_mbx = ref_mbx;
        this.scoreboard_mbx = scoreboard_mbx;
        
        foreach(RAM[i]) begin
            RAM[i] = 0;
         end
    endfunction

    task run();
        RAM_transaction tr, ref_tr;
        forever begin
            ref_mbx.get(tr);
            if(tr.w_enb == 1) begin
                RAM[tr.w_addr] = tr.data_in;
            end
            else begin
                ref_tr = new();
                ref_tr.data_out = RAM[tr.rd_addr];
                scoreboard_mbx.put(ref_tr);
            end
        end
    endtask
endclass