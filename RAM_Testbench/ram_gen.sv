`include "ram_trs.sv"

class RAM_generator;
    mailbox #(RAM_transaction) w_mbx;
    mailbox #(RAM_transaction) rd_mbx;
    int unsigned write_count, read_count;

    function new(mailbox #(RAM_transaction) w_mbx, 
                 mailbox #(RAM_transaction) rd_mbx,
                 int unsigned write_count,
                 int unsigned read_count);

        this.w_mbx = w_mbx;
        this.rd_mbx = rd_mbx;
        this.write_count = write_count;
        this.read_count = read_count;

    endfunction

    task run();
        RAM_transaction tr;
        repeat(write_count) begin
            tr = new();
            if(!tr.randomize() with {w_enb == 1;}) begin
                $display("Failed to randomize");
                $finish;
            end
        else
            w_mbx.put(tr);
        end
        repeat(read_count) begin
            tr = new();
            if(!tr.randomize() with {w_enb == 0;}) begin
                $display("Failed to randomize");
                $finish;
            end
            else
                rd_mbx.put(tr);
        end
    endtask
endclass
