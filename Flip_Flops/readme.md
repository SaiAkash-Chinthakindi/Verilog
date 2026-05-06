# Verilog Flip-Flops

This repository contains the Verilog HDL implementation and testbenches of basic flip-flops used in Digital Electronics and VLSI Design.

## Flip-Flops Included

- SR Flip-Flop
- D Flip-Flop
- JK Flip-Flop
- T Flip-Flop

Each flip-flop includes:
- Verilog design file
- Testbench file
- Positive-edge triggered sequential logic
- Active-low asynchronous reset

---

## Folder Structure

```text
Flip_Flops/
│
├── SR_FlipFlop/
│   ├── S_R_FF.v
│   └── S_R_FF_tb.v
│
├── D_FlipFlop/
│   ├── D_FF.v
│   └── D_FF_tb.v
│
├── JK_FlipFlop/
│   ├── J_K_FF.v
│   └── J_K_FF_tb.v
│
├── T_FlipFlop/
│   ├── T_FF.v
│   └── T_FF_tb.v
│
└── README.md
```

---

## Tools Used

- Verilog HDL
- Xilinx Vivado
- EDA Playground

---

## Truth Tables

### SR Flip-Flop

| S | R | Operation |
|---|---|---|
| 0 | 0 | Hold |
| 0 | 1 | Reset |
| 1 | 0 | Set |
| 1 | 1 | Invalid |

---

### D Flip-Flop

| D | Q(next) |
|---|---|
| 0 | 0 |
| 1 | 1 |

---

### JK Flip-Flop

| J | K | Operation |
|---|---|---|
| 0 | 0 | Hold |
| 0 | 1 | Reset |
| 1 | 0 | Set |
| 1 | 1 | Toggle |

---

### T Flip-Flop

| T | Operation |
|---|---|
| 0 | Hold |
| 1 | Toggle |

---

## Features

- Beginner-friendly Verilog code
- Separate testbenches for simulation
- Sequential circuit design examples
- Easy to simulate and understand

---

## Author

Sai Akash

---

## License

This project is open-source and available for learning purposes.
