`include "ram_trs.sv"

class RAM_generator;
  mailbox #(RAM_transaction) generator_mbx;
  int unsigned counter

  function new(mailbox #(RAM_transaction) generator_mbx,
                 int unsigned write_count,
                 int unsigned read_count);

    this.generator_mbx = generator_mbx;
    this.counter = counter;

  endfunction

  task run();
    RAM_transaction tr;
      for(int i = 0; i < counter; i++) begin
        tr = new();
        if(i == 0) begin
          if(!tr.randomize() with {w_enb == 0;}) begin
            $display("Failed to randomize");
            $finish;
          end
        end
        else begin
          if(!tr.randomize()) begin
            $display("Failed to randomize");
            $finish;
          end
        end
        generator_mbx.put(tr);
      end
  endtask
endclass
