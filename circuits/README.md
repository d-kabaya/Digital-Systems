# Logisim circuits

Open these with **[Logisim-evolution](https://github.com/logisim-evolution/logisim-evolution)** 3.8 or newer. Use the **Poke tool** (the hand icon) to click inputs on and off.

| File | Lesson | What it shows | Try this |
|---|---|---|---|
| `combination_lock_multiple_codes.circ` | [2.1](../lessons/04-combinational-circuits.md) | Release = A·B̅·C + A̅·B·C̅, set with a 3-way DIP switch and shown on an LED | Set ABC = 101 and then 010 (LED on). Try 111 (LED off). |
| `decoder.circ` | [2.6](../lessons/07-building-blocks.md) | 3-to-8 decoder as an AND-gate tree, next to Logisim's built-in Decoder | Set the 3 input pins to 101. Output 5 lights in both versions. |
| `multiplexer.circ` | [2.6](../lessons/07-building-blocks.md) | 8-channel MUX as a tree of 2-input MUXes (AND/OR), plus the built-in version | Set select = 011, then toggle input 3 and watch the output follow it. |
| `demultiplexer.circ` | [2.6](../lessons/07-building-blocks.md) | 8-channel DEMUX: the decoder tree with the data input fed in | Set input = 1, then change select and watch which LED lights. |
| `nor_rom.circ` | [2.6](../lessons/07-building-blocks.md) | NOR-type ROM: decoder + nMOS transistor array + pull-up resistors | Every crossing has a transistor, so every word reads 00. Delete a transistor and that bit becomes 1. |
| `nand_rom.circ` | [2.6](../lessons/07-building-blocks.md) | NAND-type ROM: inverted decoder + series transistor chains | Note that every word line *except* the selected one is active. |
| `simple_alu.circ` | [2.6](../lessons/07-building-blocks.md) | 4-bit ALU: adder, subtractor, multiplier and divider feeding a MUX | Opcode 00 = +, 01 = −, 10 = ×, 11 = ÷ |
| `combinational_divider_and_multiplier.circ` | [3.2](../lessons/09-multiplication-division.md) | 4-stage subtract-and-MUX divider (with a divide-by-zero LED) and an AND + adder array multiplier | Divide 1101 by 0011 and check that quotient = 4, remainder = 1. |
| `latches.circ` | [4.1](../lessons/11-latches-and-flip-flops.md) | SR NOR latch, NAND (S̄R̄) latch, gated SR latches (AND+NOR and NAND-only), gated D latches | Press S, release it, and see Q stay at 1. Then press R. |
| `flip_flops.circ` | [4.1](../lessons/11-latches-and-flip-flops.md) | Master–slave SR flip-flops built from gates, plus Logisim's SR, D, JK and T flip-flops with asynchronous set/reset | Toggle CLK 0 → 1 and watch Q change only on the rising edge. |
| `ram_idea.circ` | [4.2](../lessons/12-synchronous-circuits.md) | A small RAM built as a grid of D-latch cells with an address decoder and Write Enable, next to Logisim's RAM component | Pick an address, set the data, pulse Write Enable, then read it back. |
| `fsm_example.circ` | [4.3](../lessons/13-finite-state-machines.md) | FSM design example 1: 2 D flip-flops generating the sequence 1, 2, 5, 7 (D₀ = Q̄₀, D₁ = Q₁ ⊕ Q₀) | Run the clock (Ctrl+K) and read O₂O₁O₀ on the LEDs. |
| `hex_code_printer.circ` | [4.3](../lessons/13-finite-state-machines.md) | FSM design example 2: keyboard → register → nibble MUX → hex ROM → TTY, driven by a 4-state Mealy controller | Run the clock, type a key, and see its hex code printed (e.g. "K" prints "4B "). |
