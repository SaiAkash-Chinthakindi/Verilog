# Registers

This folder has my Verilog code for the four basic register types you learn in a digital design course: PIPO, PISO, SIPO and SISO. For most of them I wrote two versions of the same circuit - one built the "structural" way by wiring up individual D flip-flops (and a mux where needed), and one written the "behavioral" way using a single always block. It's a good exercise to see how the same function can look totally different depending on how you describe it.

Each register is 4 bits wide (except SISO, which just shifts one bit at a time through 4 stages) and resets to 0 when rst is high.

## PIPO - Parallel In, Parallel Out

Files: `pipo.v` (structural) and `pipo1.v` (behavioral)

All 4 input bits get loaded in at once on a clock edge, and all 4 output bits are available at the same time too.

Ports: `in[3:0]`, `clk`, `rst`, `q[3:0]`

## PISO - Parallel In, Serial Out

File: `piso.v`

This one loads 4 bits in parallel, then shifts them out one bit at a time. There's a `load` signal that decides whether the register is grabbing new parallel data or just shifting what it already has - a mux in front of each flip-flop picks between the two.

Ports: `in[3:0]`, `load`, `clk`, `rst`, `q`

## SIPO - Serial In, Parallel Out

Files: `sipo.v` (structural) and `sipo1.v` (behavioral)

Opposite of PISO - one bit comes in per clock cycle, and once all 4 bits have shifted in, you can read them all out together.

Ports: `in`, `clk`, `rst`, `q[3:0]`

## SISO - Serial In, Serial Out

Files: `SISO.v` (structural) and `siso_1.v` (behavioral)

Bits go in one at a time and come out one at a time, delayed by 4 clock cycles as they move through the chain. Small heads up if you're comparing it to the others: the flip-flop used here resets asynchronously (as soon as rst goes high, not just on the clock edge), while PIPO, PISO and SIPO all reset synchronously.

Ports: `in`, `clk`, `rst`, `q`

Each folder also has a testbench (`_tb.v`) if you want to simulate these and check the waveforms for yourself.
