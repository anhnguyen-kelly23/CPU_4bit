# 4-bit CPU Design in Verilog

## 1. Overview
This project implements a simple **4-bit CPU** using Verilog HDL.  
The design executes a fixed sequence of instructions stored in an internal memory and processes 4-bit data using an ALU.

The system demonstrates how a basic processor operates through:
- instruction fetch
- execution
- result storage

---

## 2. Architecture

The CPU consists of the following modules:

### Instruction Memory (MEM)
- Stores 16 instructions (ADDR = 4-bit)
- Each instruction is a **13-bit data frame**:
  - A (4-bit)
  - B (4-bit)
  - C_IN (1-bit)
  - OP_CODE (4-bit)
- Outputs instruction based on address from Control Unit

### Control Unit (CU)
- Implements a simple FSM with 3 states:
  - Fetch
  - Execute
  - Done
- Responsibilities:
  - Reads instruction from memory
  - Extracts A, B, C_IN, OP_CODE
  - Controls memory enable and ALU enable
  - Increments instruction address

### Register Blocks
- 4-bit registers used for:
  - Operand A
  - Operand B
  - Operation code (OP)
  - Output result (Y)
- Load data based on control signals

### ALU (Arithmetic Logic Unit)
Performs operations based on `OP_CODE`:

| OP_CODE | Operation |
|--------|----------|
| 0000 | Y = A |
| 0001 | Y = A + 1 |
| 0010 | Y = A + B |
| 0011 | Y = A + B + C_IN |
| 0100 | Y = A - B |
| 0101 | Y = A - B + C_IN |
| 0110 | Y = A - 1 |
| 0111 | Y = A |
| 1000 | Y = A AND B |
| 1001 | Y = A OR B |
| 1010 | Y = A XOR B |
| 1011 | Y = ~A |
| 1100 | Y = 0 |
| 1101 | Y = A << 1 |
| 1110 | Y = A >> 1 |
| 1111 | Y = rotate left A |

- Arithmetic operations implemented using a 4-bit ripple-carry add/sub structure

---

## 3. System Operation

Each instruction follows this sequence:

1. **Fetch**
   - Read instruction from memory
   - Load A, B, OP_CODE, C_IN into registers

2. **Execute**
   - Enable ALU
   - Perform operation

3. **Write Back**
   - Store result into output register Y

The system automatically executes all instructions from address 0 to 15.

---

## 4. Project Structure
├── src/
│ └── CPU_final.v # Full CPU design (MEM + CU + ALU + Registers)
│
├── tb/
│ └── CPU_final_tb.v # Testbench
│
├── docs/
│ └── CPU.pptx # Presentation
│
├── .gitignore
└── README.md


---

## 5. Simulation

The testbench:
- Generates clock and reset
- Runs through all instructions (ADDR = 0 → 15)
- Displays result for each instruction

Example output:
Instr 0: ...
Instr 1: ...
...
Instr15: ...

### Run with ModelSim
vlog src/CPU_final.v tb/CPU_final_tb.v
vsim cpu_final_tb
run -all


---

## 6. Key Characteristics
- 4-bit datapath
- Internal instruction memory (no external input)
- FSM-based control unit
- Sequential execution of instructions
- Modular RTL design

---

## 7. Notes
- Instructions are hard-coded in memory (MEM module)
- No external instruction input or branching
- Designed for learning CPU architecture and RTL design

---

## 8. Author
Nguyen Minh Anh  
VNUHCM - University of Science





