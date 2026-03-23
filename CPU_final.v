
module MEM (
    input clk, EN,
    input [3:0] ADDR, // Địa chỉ 4 bit
    output reg [12:0] DATA_FRAME
);
    always @(posedge clk) begin
        if (EN) begin
            case (ADDR)
                4'b0000: DATA_FRAME = 13'b0000_0000_0_0000; // Y = A (A=0)
                4'b0001: DATA_FRAME = 13'b0000_0000_1_0001; // Y = A + 1 (A=0, C_IN=1)
                4'b0010: DATA_FRAME = 13'b0000_0001_0_0010; // Y = A + B (A=0, B=1)
                4'b0011: DATA_FRAME = 13'b0001_0010_1_0011; // Y = A + B + 1 (A=1, B=2)
                4'b0100: DATA_FRAME = 13'b0010_0011_0_0100; // Y = A - B (A=2, B=3)
                4'b0101: DATA_FRAME = 13'b0011_0100_1_0101; // Y = A - B + C_IN (A=3, B=4)
                4'b0110: DATA_FRAME = 13'b0100_0001_0_0110; // Y = A - 1 (A=4, B=1)
                4'b0111: DATA_FRAME = 13'b0101_0110_1_0111; // Y = A (A=5, B=6)
                4'b1000: DATA_FRAME = 13'b0110_0111_0_1000; // Y = A AND B (A=6, B=7)
                4'b1001: DATA_FRAME = 13'b0111_1000_0_1001; // Y = A OR B (A=7, B=8)
                4'b1010: DATA_FRAME = 13'b1000_1001_0_1010; // Y = A XOR B (A=8, B=9)
                4'b1011: DATA_FRAME = 13'b1001_1010_0_1011; // Y = ~A (A=9, B=10)
                4'b1100: DATA_FRAME = 13'b1010_1011_0_1100; // Y = 0 (A=10, B=11)
                4'b1101: DATA_FRAME = 13'b1011_0000_0_1101; // Y = A << 1 (A=11, B=0)
                4'b1110: DATA_FRAME = 13'b1100_0000_0_1110; // Y = A >> 1 (A=12, B=0)
                4'b1111: DATA_FRAME = 13'b1101_0000_0_1111; // Y = rotate left A (A=13, B=0)
                default: DATA_FRAME = 13'b0000_0000_0_0000;
            endcase
        end
    end
endmodule


// Module ALU: Ðon v? x? lý s? h?c và logic
module ALU (
    input [3:0] A, B,
    input C_IN,
    input [3:0] OP_CODE,
    input EN,
    output reg [3:0] Y
);
    wire [3:0] addsub_result;
    wire [3:0] addsub_cout;

    // Instantiate 4-bit adder/subtractor using addsub_1bit
    addsub_1bit bit0 (
        .A(A[0]),
        .B(B[0]),
        .control(OP_CODE[2] | OP_CODE[1]), // control = 1 for subtraction (OP_CODE 4'b0100, 4'b0101)
        .Cin(C_IN),
        .S(addsub_result[0]),
        .Cout(addsub_cout[0])
    );

    addsub_1bit bit1 (
        .A(A[1]),
        .B(B[1]),
        .control(OP_CODE[2] | OP_CODE[1]),
        .Cin(addsub_cout[0]),
        .S(addsub_result[1]),
        .Cout(addsub_cout[1])
    );

    addsub_1bit bit2 (
        .A(A[2]),
        .B(B[2]),
        .control(OP_CODE[2] | OP_CODE[1]),
        .Cin(addsub_cout[1]),
        .S(addsub_result[2]),
        .Cout(addsub_cout[2])
    );

    addsub_1bit bit3 (
        .A(A[3]),
        .B(B[3]),
        .control(OP_CODE[2] | OP_CODE[1]),
        .Cin(addsub_cout[2]),
        .S(addsub_result[3]),
        .Cout(addsub_cout[3])
    );

    always @(*) begin
        if (EN) begin
            case (OP_CODE)
                4'b0000: Y = A;                          // Truyền/gán
                4'b0001: Y = addsub_result;              // Tăng 1 (A + 1, using addsub with B=0, C_IN=1)
                4'b0010: Y = addsub_result;              // Cộng (A + B)
                4'b0011: Y = addsub_result;              // Cộng với nhớ (A + B + C_IN)
                4'b0100: Y = addsub_result;              // A - B
                4'b0101: Y = addsub_result;              // A - B + C_IN
                4'b0110: Y = addsub_result;              // Giảm 1 (A - 1, using addsub with B=0)
                4'b0111: Y = A;                          // Truyền/gán
                4'b1000: Y = A & B;                      // AND
                4'b1001: Y = A | B;                      // OR
                4'b1010: Y = A ^ B;                      // XOR
                4'b1011: Y = ~A;                         // Lấy bù 1
                4'b1100: Y = 4'b0000;                    // Gán zero
                4'b1101: Y = A << 1;                     // Dịch trái
                4'b1110: Y = A >> 1;                     // Dịch phải
                4'b1111: Y = {A[2:0], A[3]};            // Xoay trái
                default: Y = 4'b0000;
            endcase
        end else begin
            Y = 4'b0000;
        end
    end
endmodule
//
module addsub_1bit(
    input A,
    input B,
    input control,  // 0: cong, 1: tru
    input Cin,      // Carry in (tu bit truoc)
    output S,
    output Cout
);

    wire B_xor;

    assign B_xor = B ^ control;       // Dao B neu la phep tru
    assign S     = A ^ B_xor ^ Cin;   // Cong theo full adder
    assign Cout  = (A & B_xor) | (Cin & (A ^ B_xor)); // Carry out (hoac Borrow out neu tru)

endmodule
//



// Module Control Unit: Ði?u khi?n tr?ng thái
module ControlUnit (
    input clk, reset,
    input [12:0] DATA_FRAME,
    output reg [3:0] A_IN, B_IN, OP_CODE,
    output reg [3:0] ADDR,
    output reg ALU_EN, MEM_EN,
    output C_IN
);
    reg [1:0] current_state, next_state;
    reg C_IN_reg;
    parameter [1:0] Fetch = 2'b00, Execute = 2'b01, Done = 2'b10;

    assign C_IN = C_IN_reg;

  always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= Fetch;
            ADDR <= 4'b0000;
            A_IN <= 4'b0000;
            B_IN <= 4'b0000;
            OP_CODE <= 4'b0000;
            C_IN_reg <= 1'b0;
        end else begin
            current_state <= next_state;
            if (current_state == Fetch) begin
                A_IN <= DATA_FRAME[12:9];
                B_IN <= DATA_FRAME[8:5];
                C_IN_reg <= DATA_FRAME[4];
                OP_CODE <= DATA_FRAME[3:0];
                if (ADDR < 4'b1111)
                    ADDR <= ADDR + 1;
            end
        end
    end

    always @(*) begin
        case (current_state)
            Fetch: begin
                MEM_EN = 1'b1;
                ALU_EN = 1'b0;
                if (ADDR <= 4'b1111)
                    next_state = Execute;
                else
                    next_state = Done;
            end
            Execute: begin
                MEM_EN = 1'b0;
                ALU_EN = 1'b1;
                next_state = Fetch;
            end
            Done: begin
                MEM_EN = 1'b0;
                ALU_EN = 1'b0;
                next_state = Done;
            end
            default: begin
                MEM_EN = 1'b0;
                ALU_EN = 1'b0;
                next_state = Fetch;
            end
        endcase
    end
endmodule



// ------------------------------------------------------------------
// Module Reg4: thanh ghi 4 bit có load
// ------------------------------------------------------------------
module Reg4 (
    input clk,
    input reset,
    input load,
    input [3:0] D,
    output reg [3:0] Q
);
  always @(posedge clk or posedge reset) begin
        if (reset) Q <= 4'b0000;
        else if (load) Q <= D;
    end
endmodule



// ------------------------------------------------------------------
// Module system: K?t n?i MEM, ControlUnit, Reg4 và ALU
// ------------------------------------------------------------------
// Module system: K?t n?i MEM, ControlUnit, Reg4 và ALU
module CPU_final(
    input clk,
    input reset,
    output [3:0] Y,
    output [3:0] A_OUT,
    output [3:0] B_OUT,
    output [3:0] OP_OUT,
    output C_IN
);
    wire MEM_EN, ALU_EN;
    wire [3:0] ADDR;
    wire [12:0] DATA_FRAME;
    wire [3:0] cuA, cuB, cuOP;
    wire cuCIN;
    wire [3:0] aluY;

    MEM U_MEM (
      .clk(clk),
        .EN(MEM_EN),
        .ADDR(ADDR),
        .DATA_FRAME(DATA_FRAME)
    );

    ControlUnit U_CU (
      .clk(clk),
        .reset(reset),
        .DATA_FRAME(DATA_FRAME),
        .A_IN(cuA),
        .B_IN(cuB),
        .OP_CODE(cuOP),
        .ADDR(ADDR),
        .ALU_EN(ALU_EN),
        .MEM_EN(MEM_EN),
        .C_IN(cuCIN)
    );

    Reg4 U_REGA (
      .clk(clk),
        .reset(reset),
        .load(MEM_EN),
        .D(cuA),
        .Q(A_OUT)
    );
    Reg4 U_REGB (
      .clk(clk),
        .reset(reset),
        .load(MEM_EN),
        .D(cuB),
        .Q(B_OUT)
    );
    Reg4 U_REGOP (
      .clk(clk),
        .reset(reset),
        .load(MEM_EN),
        .D(cuOP),
        .Q(OP_OUT)
    );

    ALU U_ALU (
        .A(A_OUT),
        .B(B_OUT),
        .C_IN(cuCIN),
        .OP_CODE(OP_OUT),
        .EN(ALU_EN),
        .Y(aluY)
    );

    Reg4 U_REGY (
      .clk(clk),
        .reset(reset),
        .load(ALU_EN),
        .D(aluY),
        .Q(Y)
    );



    assign C_IN = cuCIN;
endmodule
