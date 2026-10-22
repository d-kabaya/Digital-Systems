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
