# Lesson 2.6 — Combinational Building Blocks: Decoder, Multiplexer, Demultiplexer, ALU, ROM

> Based on lecture slides **2.6 Combinational building blocks of digital systems** (COMP20020).
> ⬅️ [2.4 Simplification](06-simplification-universal-gates.md) · [Index](../README.md) · ➡️ [3.1 Signed Integers](08-signed-integers.md)

## What are we learning?

A simple computer contains a handful of standard parts. Many of them are **purely combinational**: **decoders**, **multiplexers**, **demultiplexers**, the **ALU**, and **ROM**. This lesson explains what each one does and how it's built. All of them have Logisim files in [`circuits/`](../circuits/).

```
 Destination reg ─► [Decoder] ─► Registers 0..n ─► [MUX] ─► Operand A ─┐
                                                   [MUX] ─► Operand B ─┴► [ALU]
 Program counter ─► [ROM: program] ─► instruction decoder ─► control signals
```

---

## 1. Decoder (1-of-n)

- It has **n inputs** and **2ⁿ outputs**.
- Exactly **one** output is 1 (the one whose number matches the binary input). All the others are 0. This is called "one-hot".

A 2-to-4 decoder:

| S₁ S₀ | Out₀ | Out₁ | Out₂ | Out₃ |
|---|---|---|---|---|
| 0 0 | **1** | 0 | 0 | 0 |
| 0 1 | 0 | **1** | 0 | 0 |
| 1 0 | 0 | 0 | **1** | 0 |
| 1 1 | 0 | 0 | 0 | **1** |

Each output is just one minterm: Out₀ = S̅₁S̅₀, Out₁ = S̅₁S₀, Out₂ = S₁S̅₀, Out₃ = S₁S₀.

**"Tree" design:** a 3-to-8 decoder splits the choice into levels. The first select bit picks between 2 branches, the next splits each branch into 2, and so on, giving 2 → 4 → 8. Your [`decoder.circ`](../circuits/decoder.circ) builds this tree from AND gates (some with inverted inputs) and puts Logisim's built-in Decoder next to it for comparison.

**What it's used for:** choosing *which* register or memory row to activate.

## 2. Buses and wire names

- A **bus** is a group of wires that carries a multi-bit value. In Logisim it's called a "wire bundle" and drawn thicker.
- Individual bits are named with brackets: `Address[7]` … `Address[0]`.
- **MSB** = most significant bit (leftmost). **LSB** = least significant bit (rightmost).
- In Logisim, a **splitter** breaks a bus into its separate wires, or joins wires into a bus.

## 3. Multiplexer (MUX), the "selector"

A MUX **chooses one of its inputs** and passes it to the single output. The **select** lines decide which one.

A 2-input MUX:

| SEL | Z |
|---|---|
| 0 | A (input 0) |
| 1 | B (input 1) |

**Z = SEL̅·A + SEL·B.** This matches your [handwritten 1-bit MUX table](../worked-examples/1bit-multiplexer-truth-table.jpeg).

- An **8-input MUX** needs **3 select bits** (2³ = 8).
- A MUX can switch whole **buses**, e.g. choose between two 4-bit numbers.
- Your [`multiplexer.circ`](../circuits/multiplexer.circ) builds an 8-channel MUX as a **tree of 2-input MUXes** (AND/OR pairs). Select bit 0 is used at the first level, bit 1 at the second, and bit 2 at the last.

> 💡 A good way to remember it: a MUX works like a **rotary switch on a stereo**. Several sources go in, one comes out, and the knob is the select input.

## 4. Demultiplexer (DEMUX)

A DEMUX is the **opposite** of a MUX. It takes **one input** and sends it to **one of several outputs**, chosen by select. All the other outputs are 0.

| SEL | Out₀ | Out₁ |
|---|---|---|
| 0 | IN | 0 |
| 1 | 0 | IN |

A DEMUX is basically **a decoder whose outputs are each ANDed with the input signal**. Compare [`demultiplexer.circ`](../circuits/demultiplexer.circ) with `decoder.circ`. They're the same tree, except the DEMUX has the data input fed into the first level.

## 5. Arithmetic-Logic Unit (ALU)

An ALU is a combinational circuit that can do **several operations** on X and Y. An **operation code** chooses which one.

**The simple design:** build every operation side by side, then use a **MUX** controlled by the opcode to pick which result goes out.

Your [`simple_alu.circ`](../circuits/simple_alu.circ) does exactly this with 4-bit X and Y:

| Opcode | Operation |
|---|---|
| 00 | X + Y |
| 01 | X − Y |
| 10 | X × Y |
| 11 | X ÷ Y |

## 6. Read-Only Memory (ROM)

**A ROM is a truth table built directly in hardware.**

- **Address** = the inputs, which choose a row.
- **Data** = the outputs, the stored word for that row.

Structure:

1. A **decoder** turns the address into one active **word line** (one row).
2. A grid of transistors connects word lines to **bit lines** (the data outputs).
3. Whether or not a transistor sits at each crossing stores a 0 or a 1.

Example from the slides (3-bit address, 8-bit data): address 011 → data 0001 0100 (= 14₁₆).

### NOR-type vs NAND-type ROM

| | NOR-type | NAND-type |
|---|---|---|
| Transistor layout | each one connects to its bit line **separately** (in parallel, like the nMOS in a NOR gate) | the transistors for one bit are **in series**, forming the bit line (like the nMOS in a NAND gate) |
| How it's read | the selected word line turns its transistors ON, pulling those bit lines to 0 | every word line *except* the selected one is turned ON |
| Encoding | **no transistor = 1** | **a working transistor = 1** (a short-circuited spot = 0) |
| Density | lower | **higher** (packs more bits per area) |

See [`nor_rom.circ`](../circuits/nor_rom.circ) and [`nand_rom.circ`](../circuits/nand_rom.circ). Each one has a transistor array next to Logisim's built-in ROM component holding the matching contents. The NOR version starts with every transistor present (all 00), and the NAND version starts with all FF.

### Reading a hex dump

Memory contents are often shown as a **hexadecimal dump**:

```
0000  48 65 6C 6C 6F 20 57 6F-72 6C 64 0D 0A 00 8B CF   Hello World.....
0010  C1 E3 02 C4 3E 50 56 26-29 01 8B 46 34 00 63 14   ....>PV&)..F4.c.
0020  1E 50 56 26 01 41 02 FF-76 FC 8B 5E FA 53 8B 56   .PV&.A..v..^.S.V
```

- The left column is the address of the **first** byte on that row (each row holds 16 bytes = 10₁₆).
- To find address 0023: go to row 0020, then count 0, 1, 2, **3** → **26₁₆**.
- The right-hand column shows the same bytes as ASCII text, where that makes sense. For example, 48 = 'H' and 65 = 'e'.

---

## Common mistakes

- Mixing up MUX and DEMUX. A **MUX** is many in, one out. A **DEMUX** is one in, many out.
- Getting the number of select bits wrong. For k inputs you need log₂k bits, so 8 inputs need 3.
- Counting a hex dump from 1 instead of 0.
- Thinking a ROM needs a clock. It's combinational: the data appears as soon as the address does (after the propagation delay).

## Quick summary

- **Decoder:** n → 2ⁿ, one-hot output.
- **MUX:** pick one input. **DEMUX:** route one input to a chosen output.
- **ALU:** compute everything, then use a MUX to pick the result by opcode.
- **ROM:** a decoder plus a transistor grid, i.e. a truth table in hardware. NAND-type is denser.

---

## 📝 Quiz

**Q1.** How many outputs does a 4-input decoder have? How many of them are 1 at once?

<details><summary>Answer</summary>

2⁴ = **16 outputs**, and **exactly one** is 1.
</details>

**Q2.** How many select bits does a 16-input multiplexer need?

<details><summary>Answer</summary>

log₂16 = **4**
</details>

**Q3.** Write the Boolean expression for a 2-input MUX with inputs A (selected by 0) and B (selected by 1).

<details><summary>Answer</summary>

**Z = S̅·A + S·B**
</details>

**Q4.** What is the main difference between a decoder and a demultiplexer?

<details><summary>Answer</summary>

A decoder's chosen output is always **1**. A demultiplexer's chosen output carries the **data input's value**, so it's 0 or 1. You can build a DEMUX from a decoder by ANDing each output with the data input.
</details>

**Q5.** In `simple_alu.circ`, X = 0110 and Y = 0010, and the opcode is 01. What is the output?

<details><summary>Answer</summary>

Opcode 01 is subtract: 6 − 2 = 4 = **0100**.
</details>

**Q6.** In a NOR-type ROM, what does a *missing* transistor encode?

<details><summary>Answer</summary>

A **1**. Nothing pulls that bit line down to 0.
</details>

**Q7.** Which ROM type is denser, and why?

<details><summary>Answer</summary>

**NAND-type.** Its transistors are chained in series, so they share connections and pack more tightly than NOR-type transistors, each of which needs its own connection to the bit line.
</details>

**Q8.** Using the hex dump above, what byte is stored at address 0017? And at 000B?

<details><summary>Answer</summary>

- Row 0010, position 7: **26₁₆**
- Row 0000, position B (11): **0D₁₆**, which is the CR control character.
</details>

**Q9.** Which components of a simple computer can be built as purely combinational circuits?

<details><summary>Answer</summary>

The **decoders, multiplexers, ALU and ROM**. Registers and RAM need memory, so they're sequential.
</details>
