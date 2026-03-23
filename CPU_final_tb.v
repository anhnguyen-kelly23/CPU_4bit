`timescale 1ns/1ps

module cpu_final_tb;
    reg        clk, reset;
    wire [3:0] Y;
    wire [3:0] A_OUT, B_OUT, OP_OUT;
    wire       C_IN;

    system uut (
        .clk     (clk),
        .reset   (reset),
        .Y       (Y),
        .A_OUT   (A_OUT),
        .B_OUT   (B_OUT),
        .OP_OUT  (OP_OUT),
        .C_IN    (C_IN)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("cpu_4bit_full.vcd");
        $dumpvars(0, cpu_4bit_full_tb);

        reset = 1;
        #10;
        reset = 0;

        #40; $display("Instr 0: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 0)",
            OP_OUT, A_OUT, B_OUT, C_IN, Y);
        #20; $display("Instr 1: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 1)",
            OP_OUT, A_OUT, B_OUT, C_IN, Y);
        #20; $display("Instr 2: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 1)",
            OP_OUT, A_OUT, B_OUT, C_IN, Y);
        #20; $display("Instr 3: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 4)",
            OP_OUT, A_OUT, B_OUT, C_IN, Y);
        #20; $display("Instr 4: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 15)",
            OP_OUT, A_OUT, B_OUT, C_IN, Y);
        #20; $display("Instr 5: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 15)",
            OP_OUT, A_OUT, B_OUT, C_IN, Y);
        #20; $display("Instr 6: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 3)",
            OP_OUT, A_OUT, B_OUT, C_IN, Y);
        #20; $display("Instr 7: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 5)",
            OP_OUT, A_OUT, B_OUT, C_IN, Y);
        #20; $display("Instr 8: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 6)",
            OP_OUT, A_OUT, B_OUT, C_IN, Y);
        #20; $display("Instr 9: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 15)",
            OP_OUT, A_OUT, B_OUT, C_IN, Y);
        #20; $display("Instr10: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 1)",
            OP_OUT, A_OUT, B_OUT, C_IN, Y);
        #20; $display("Instr11: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 6)",
            OP_OUT, A_OUT, B_OUT, C_IN, Y);
        #20; $display("Instr12: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 0)",
            OP_OUT, A_OUT, B_OUT, C_IN, Y);
        #20; $display("Instr13: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 6)", 
            OP_OUT, A_OUT, B_OUT, C_IN, Y); // Y = A << 1 (11 << 1 = 6)
        #20; $display("Instr14: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 6)", 
            OP_OUT, A_OUT, B_OUT, C_IN, Y); // Y = A >> 1 (12 >> 1 = 6)
        #20; $display("Instr15: OP=%b, A=%d, B=%d, C_IN=%b -> Y=%d (exp 11)", 
            OP_OUT, A_OUT, B_OUT, C_IN, Y); // Y = rotate left A (13 = 1101 -> 1011 = 11)
      
        #100;
        $finish;
    end
endmodule
