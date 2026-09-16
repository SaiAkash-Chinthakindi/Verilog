# Asynchronous FIFO (Verilog + SystemVerilog Testbench)

## What this project is
This is my implementation of an **asynchronous FIFO** — basically a FIFO where the write side and read side run on two completely different clocks. I built the sync FIFO first, and honestly thought this would just be a small extension of that, but it turned out to be a much bigger jump because now you actually have to deal with clock domain crossing (CDC), not just a simple pointer compare.

I wrote the design in Verilog and verified it with a self-checking SystemVerilog testbench.

## Files
- `FIFO_memory.v` - top module, has the actual memory array and hooks up the pointer + synchronizer modules
- `write_pointer.v` - write-side pointer logic (gray code + full flag)
- `read_pointer.v` - read-side pointer logic (gray code + empty flag)
- `synchronizers.v` - the 2-flop synchronizer that moves a pointer safely from one clock domain to the other
- `Asynchronous_FIFO_tb.sv` - my testbench

## Why this is harder than a sync FIFO
In the sync FIFO, both `write_pt` and `read_pt` update on the same clock, so comparing them directly is fine - they're always "fresh" relative to each other.

Here, the write pointer lives in `w_clk` and the read pointer lives in `r_clk`. If you try to compare them directly across domains, you can get metastability (a signal changing right as the other clock samples it), which can corrupt data or cause the `full`/`empty` logic to glitch. So this design uses two tricks to deal with that:

1. **Gray code pointers** — instead of sending the plain binary pointer across, it converts it to gray code first, where only 1 bit changes between any two consecutive values. So even if it gets sampled at a slightly wrong moment, worst case it's off by one count, not a totally random value.
2. **Double flip-flop synchronizer** (`synchronizers.v`) - the pointer goes through 2 flip-flops in the receiving clock's domain before it's "trusted." This adds a 2-cycle delay, but it's the standard way to avoid metastability.

### The tricky part — full/empty
Since the pointer info coming from the other domain is always a couple cycles old, you can't just compare "my pointer now" vs "their pointer now" because "their pointer now" is actually stale info. So `full` and `empty` are calculated using the pointer's **next** value (before the clock edge even happens) compared against the synchronized version of the other side. This way the flag is correct exactly on time instead of one cycle late, which actually matters - if `full` came one cycle late you could write past the end of the FIFO.

This took me a while to actually get - I originally thought it was overcomplicating things, but once I actually traced through it with numbers it made sense (the write side is always looking at the read pointer's "old news," so it has to be a little paranoid and check one step ahead).

## Testbench
Since the write and read sides run on separate clocks, I didn't need `fork...join` to make them "simultaneous" like I did for my sync FIFO testbench - here they're just two separate `initial` blocks, each running on its own clock, and they're actually concurrent for real (not just same-timestamp like fork is).

I used a queue (`buffer[$]`) as a scoreboard/reference model — every time I write, I push into it, every time I read, I pop from it and compare with the DUT's real output.

**Tasks:**
- `write_fifo` / `read_fifo` - one write or one read, checks `full`/`empty` first
- `write_till_full` — keeps calling `write_fifo` until the DUT says `full`, instead of me hardcoding "write 8 times"
- `read_till_empty` — same idea but for draining it
- After that there's also a phase where both sides just keep writing/reading randomly with random gaps in between, to stress it a bit more realistically instead of everything happening in a neat lockstep pattern

I made `w_clk` faster than `r_clk` (10ns vs 14ns) just so the FIFO would actually fill up during my fill test. That's not a rule of async FIFOs btw — I originally thought write had to be slower than read for some reason, but it turns out it doesn't matter which one is faster, the whole point of this design is that it works either way.

## What I tested
1. Reset — `full` should be 0, `empty` should be 1
2. Fill it up completely and check `full` goes high
3. Drain it completely and check every value matches what I expect, and `empty` goes high again
4. Random mixed writes/reads with random gaps, both sides independent
5. Final drain + pass/fail count printed at the end

## Sample output from my sim
```
time = 190000, FIFO became full after 8 writes
time = 190000, pass => actual data = 1, expected data = 1.
time = 210000, pass => actual data = 100100, expected data = 100100.
...
time = 910000, pass => actual data = 11000101, expected data = 11000101.
time = 910000, FIFO became empty after 26 reads
time = 910000, pass => actual data = 1, expected data = 1.
```

It correctly filled after exactly 8 writes (matches my depth = 8). The 26 reads number looks bigger than 8 because by the time my read side started draining, the write side had already moved on and written more data - so more stuff had piled up in my reference queue than just the original 8. All the data comparisons came back as pass.

(Note: this is just a chunk of my log - the random mixed phase and the final pass/fail total happen later in sim time, so I need to let it run a bit longer to catch the full summary line.)

## How to run it
1. Add all the RTL files + the testbench to your simulator (I used Vivado)
2. Set `Asynchronous_FIFO_tb` as top
3. Run for at least ~2000ns so it gets through the random phase too
4. Check the console log for the final pass/fail count

## Stuff I learned doing this
- Why you can't just compare pointers directly once they're on different clocks
- What gray code actually buys you in a CDC context (only 1 bit changes at a time)
- Why `full`/`empty` need to be calculated from the "next" pointer value, not the current one - otherwise you're one cycle late and can overflow
- That fork/join isn't needed here since the two domains are naturally running in parallel already
- That there's no rule about which clock has to be faster - I had that backwards at first

## Things I'd want to add later if I keep working on this
- Randomize the clock periods every run instead of hardcoding 10ns/14ns, to actually prove it works at different speed ratios
- Add some coverage so I can see if I'm actually hitting corner cases like near-full/near-empty
- Maybe try writing this as a UVM testbench eventually once I learn more UVM
