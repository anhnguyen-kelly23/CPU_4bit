# 4-bit CPU Design in Verilog

## 1. Overview

This project implements a simple **4-bit CPU** using Verilog HDL. The design executes a fixed sequence of instructions stored in an internal memory and processes 4-bit data using an ALU.

The system demonstrates how a basic processor operates through **instruction fetch**, **execution**, and **result storage**.

---

## 2. Architecture

The CPU consists of the following modules:

### 2.1 Instruction Memory (MEM)

- Stores 16 instructions (ADDR = 4-bit).
- Each instruction is a **13-bit data frame**:

| Field     | Width  |
|-----------|--------|
| A         | 4-bit  |
| B         | 4-bit  |
| C_IN      | 1-bit  |
| OP_CODE   | 4-bit  |

- Outputs instruction based on address from the Control Unit.

### 2.2 Control Unit (CU)

Implements a simple FSM with 3 states:

| State   | Description                                    |
|---------|------------------------------------------------|
| Fetch   | Reads instruction from memory                  |
| Execute | Extracts A, B, C_IN, OP_CODE and enables ALU   |
| Done    | Increments instruction address                 |

### 2.3 Register Blocks

4-bit registers used for storing operands and results:

| Register | Purpose              |
|----------|----------------------|
| A        | Operand A            |
| B        | Operand B            |
| OP       | Operation code       |
| Y        | Output result        |

Registers load data based on control signals from the CU.

### 2.4 ALU (Arithmetic Logic Unit)

Performs operations based on `OP_CODE`:

| OP_CODE | Operation          |
|---------|--------------------|
| `0000`  | Y = A              |
| `0001`  | Y = A + 1          |
| `0010`  | Y = A + B          |
| `0011`  | Y = A + B + C_IN   |
| `0100`  | Y = A − B          |
| `0101`  | Y = A − B + C_IN   |
| `0110`  | Y = A − 1          |
| `0111`  | Y = A              |
| `1000`  | Y = A AND B        |
| `1001`  | Y = A OR B         |
| `1010`  | Y = A XOR B        |
| `1011`  | Y = ~A             |
| `1100`  | Y = 0              |
| `1101`  | Y = A << 1         |
| `1110`  | Y = A >> 1         |
| `1111`  | Y = rotate left A  |

> Arithmetic operations are implemented using a 4-bit ripple-carry add/sub structure.

---

## 3. System Operation

Each instruction follows this sequence:

1. **Fetch** — Read instruction from memory; load A, B, OP_CODE, C_IN into registers.
2. **Execute** — Enable ALU and perform the operation.
3. **Write Back** — Store result into output register Y.

The system automatically executes all instructions from address `0` to `15`.

---

## 4. Project Structure
```
CPU_4bit/
├── src/
│   └── CPU_final.v          # Full CPU design (MEM + CU + ALU + Registers)
├── tb/
│   └── CPU_final_tb.v       # Testbench
├── docs/
│   └── CPU.pptx             # Presentation
├── .gitignore
└── README.md
```

---

## 5. Simulation

The testbench generates clock and reset signals, then runs through all 16 instructions (ADDR = 0 → 15) and displays the result for each.

**Example output:**
```
Instr  0: ...
Instr  1: ...
...
Instr 15: ...
```

### Run with ModelSim
```bash
vlog src/CPU_final.v tb/CPU_final_tb.v
vsim cpu_final_tb
run -all
```

---

## 6. Key Characteristics

- 4-bit datapath
- Internal instruction memory (no external input)
- FSM-based control unit
- Sequential execution of instructions
- Modular RTL design

---

## 7. Notes

- Instructions are hard-coded in memory (MEM module).
- No external instruction input or branching support.
- Designed for learning CPU architecture and RTL design.

---

## 8. Author

**Nguyen Minh Anh**
VNUHCM — University of Science
