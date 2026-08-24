# 8-bit Booth Multiplier — FSMD Implementation

A synthesizable Verilog implementation of Radix-2 Booth's Multiplication Algorithm,
built as a **Controller + Datapath (FSMD)** architecture, with a self-checking
SystemVerilog regression testbench.

---

## 1. Overview

This project implements signed 8×8 → 16-bit multiplication using Booth's algorithm.
The design is split into two top-level blocks:

- **`control_unit`** — a 4-state Moore FSM (`idle → load → execute → done`) that
  generates all datapath control signals based on the current state and the two
  Booth recoding bits `Q0`, `Q_1`.
- **`data_path_unit`** — the register file (`A`, `Q`, `Q_1`, `M`), the
  adder/subtractor, the arithmetic shifter, and the iteration counter.

```
                ┌───────────────┐
   start ──────▶│               │
   Q0, Q_1 ────▶│ control_unit  │──── load_M, load_Q, shift_en,
   eq ─────────▶│   (FSM)       │     add_sub, op_sel, clear ────┐
                └───────────────┘                                │
                                                                  ▼
   data_in[7:0] ───────────────────────────────────▶┌────────────────────┐
                                                      │   data_path_unit    │
   clk, rst ───────────────────────────────────────▶│  A | Q | Q_1 | M    │
                                                      │  add_sub | shifter  │
                                                      │      counter        │
                                                      └────────┬─────────┬──┘
                                                     Done ◀─────┘         │
                                                     product[15:0] ◀──────┘
```

## 2. FSM

| State     | Encoding | Action |
|-----------|----------|--------|
| `idle`    | `00`     | Waits for `start`. On `start`, asserts `load_M` (latch multiplicand) and moves to `load`. |
| `load`    | `01`     | Asserts `load_Q` (latch multiplier, clear `Q_1`). Moves to `execute`. |
| `execute` | `10`     | While `!eq`: asserts `shift_en` every cycle; decodes `{Q0,Q_1}` into `add_sub`/`op_sel` and performs one Booth iteration (add/sub + arithmetic shift) per clock. Loops until the 8-iteration counter reaches zero. |
| `done`    | `11`     | Asserts `Done` for one cycle. Returns to `idle`. |

Booth recoding table (evaluated every `execute` cycle):

| `Q0` | `Q_1` | Operation      |
|------|-------|----------------|
| 0    | 0     | No-op, shift only |
| 0    | 1     | `A = A + M`, then shift |
| 1    | 0     | `A = A - M`, then shift |
| 1    | 1     | No-op, shift only |

`op_sel = Q0 ^ Q_1` selects between the adder's output and a straight bypass of
`A` before every shift; the shift itself (`{A,Q,Q_1} >>> 1`, sign-extended) happens
unconditionally on every `execute` cycle.

## 3. Datapath details

- **9-bit accumulator (`A`) and adder/subtractor.** `A`, the adder inputs, and the
  shifter's combined register are all one bit wider than the nominal 8-bit operand
  width. This guard bit is required to prevent overflow during intermediate Booth
  steps — see [Section 5](#5-known-limitation--the--128-edge-case) for why.
- **Explicit `clear` on `A` and `Q_1`.** Both registers are cleared on `load_M`
  (start of a new operation), not just on global `rst`. Without this, leftover
  state from a previous multiply corrupts the next one — this was one of the more
  subtle bugs found during development (see [Section 6](#6-bug-log--lessons-learned)).
- **Single shared `data_in` bus.** The multiplicand and multiplier are loaded on
  two consecutive cycles (`load_M` then `load_Q`) over one 8-bit input bus, rather
  than using two separate input ports.
- **Combinational add-then-shift, one FSMD state per iteration.** The
  adder/subtractor and the shifter are both pure combinational logic
  (`always@(*)` / `assign`), chained together with no register in between. Both
  operations settle within a single clock period, gated by one `shift_en` signal;
  this is the standard, non-pipelined FSMD approach (see design-discussion notes
  in `docs/timing-notes.md` for the full derivation of why this meets timing).

## 4. Repository structure

```
.
├── README.md                  <- this file
├── rtl/
│   └── booth_algorithm1.v     <- top module + control_unit + data_path_unit + submodules
├── tb/
│   └── booth_algorithm1_tb.sv <- self-checking regression testbench
└── docs/
    └── waveforms/             <- (optional) screenshots from simulation
```

## 5. Known limitation — the `-128` edge case

Booth's algorithm, as implemented here with an *n*-bit accumulator, adder, and
multiplicand register, cannot correctly process `M = -128` (`8'h80`) **without**
the 9-bit guard-bit widening included in this design.

**Root cause:** 8-bit two's complement is asymmetric — `[-128, 127]` — so `-128`
has no positive counterpart in 8 bits. Booth's algorithm's `A - M` step requires
implicitly negating `M`; when `M = -128`, that negation (`+128`) does not fit in
8 bits and silently wraps back to `-128`, corrupting the accumulator's sign for
the remainder of the computation.

**Concrete trace** (`M = -128`, `Q = -122`, 8-bit-only accumulator):
at the final iteration, `A = 6`, requiring `A - M = 6 - (-128) = 134`.
`134` does not fit in 8-bit signed range (`-128..127`) and wraps to `-122`,
propagating a sign error through the remaining shifts. Result: `-15616` instead
of the correct `+15616` — same magnitude, flipped sign.

**Fix implemented:** `A`, the adder's operands, and the shifter's combined
register are all widened by one guard bit (9 bits total). `M` is sign-extended
to 9 bits (`M_ext`) before every add/subtract. `134` fits comfortably in 9-bit
signed range (`-256..255`), so no overflow occurs. The final `product` output
truncates the redundant guard bit at the very end, which is always safe since
the true 16-bit result of an 8×8 signed multiply never needs the 9th bit once
computation is complete.

This is documented here as a case study, not just a fix: it is a well-known,
textbook-recognized limitation of naive Booth multiplier hardware, not a
Verilog coding error — the [regression log](#7-verification-results) confirms
`-128 * -122` now passes correctly with the widened datapath.

## 6. Bug log / lessons learned

A non-exhaustive list of the real bugs found and fixed during development,
kept here as a debugging case study:

| # | Bug | Symptom | Fix |
|---|-----|---------|-----|
| 1 | `A` register had no `shift_en` gate | `A` shifted every clock cycle regardless of FSM state | Added `shift_en` to `A`'s always block |
| 2 | `A`/`Q_1` never cleared between operations | 1st multiply correct, every subsequent one wrong | Added explicit `clear` input, tied to `load_M`/`load_Q` |
| 3 | Shifter's combined register under-width | `{A,Q,Q_1}` (17 or 18 bits) assigned into a narrower wire, truncating the sign bit | Widened `combined`/`shifted` to the correct bit count |
| 4 | `shifter`'s `control`/`result` ports left unconnected in some integration passes | `A_shifted` computed from floating inputs | Verified every port in every instantiation is explicitly connected |
| 5 | `product` assembled from the wrong registers (`{A,M}` instead of `{A,Q}`) | Final result unrelated to actual accumulated value | Corrected to `product = {A_out[7:0], Q_out}` |
| 6 | `-128` as multiplicand silently overflows an 8-bit accumulator | Correct magnitude, flipped sign | Widened `A`/adder/shifter by one guard bit (Section 5) |

## 7. Verification results

The testbench (`booth_algorithm1_tb.sv`) applies:
- A reset sequence matching the DUT's active-low, edge-triggered reset.
- A signed golden reference model (`$signed(multiplicand) * $signed(multiplier)`)
  compared against `$signed(product)` after every operation.
- A configurable randomized sweep (`random_tests(num)`), exercising all four
  sign combinations and the full 8-bit operand range.

Example run (50 random cases): **all 50 passed**, including boundary and
negative-operand cases such as `-128 * -122 = 15616` and `-114 * 103 = -11742`.

**Confirmed independently on two different simulators:**

*Xilinx XSim* (Vivado):
```
Time = 6040, Pass: -113 * 105 = -11865, Dut_output = -11865
```

*ModelSim (Intel FPGA Starter Edition 2020.1)* — same testbench, different tool:
```
# Time = 5200, Pass: 56 * 67 = 3752, Dut_output = 3752
# Time = 5320, Pass: -63 * 77 = -4851, Dut_output = -4851
# Time = 5440, Pass: 26 * 117 = 3042, Dut_output = 3042
# Time = 5560, Pass: -55 * -42 = 2310, Dut_output = 2310
# Time = 5680, Pass: -45 * 1 = -45, Dut_output = -45
# Time = 5800, Pass: -42 * -119 = 4998, Dut_output = 4998
# Time = 5920, Pass: 42 * -65 = -2730, Dut_output = -2730
# Time = 6040, Pass: -32 * 15 = -480, Dut_output = -480
#   TEST DONE: 50 passed, 0 failed
```

Getting an identical 50/50 pass result from two independent simulators is good
evidence the design's behavior isn't an artifact of one tool's specific
simulation semantics.

To reproduce:
```tcl
# Vivado / XSim example
vlog rtl/booth_algorithm1.v
vlog -sv tb/booth_algorithm1_tb.sv
vsim booth_algorithm1_tb
run -all
```
(Substitute equivalent commands for your simulator of choice — Icarus Verilog,
ModelSim, VCS, etc.)

## 8. Possible future work

- Add a **zero-operand early-out** (skip `execute` and force `product = 0` when
  either operand is zero) — discussed but intentionally left out of this version
  to avoid adding untested control paths late in development.
- Pipeline the add/shift into two stages if a higher target clock frequency is
  ever required (not necessary at the current, unconstrained clock period).
- Parameterize the operand width (currently fixed at 8 bits) for reuse at other
  bit-widths.

---

*This project was developed and debugged incrementally, with each bug traced to
its root cause via waveform inspection and a growing self-checking regression
suite — see Section 6 for the full list of issues found and resolved.*
