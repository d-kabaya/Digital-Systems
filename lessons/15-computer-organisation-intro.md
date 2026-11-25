# Lesson 5.1 — Computer Systems Organisation: Introduction

> Based on lecture slides **5.1 Computer Systems Organisation introduction** (COMP20020).
> ⬅️ [4.4 FSM Timing](14-fsm-timing.md) · [Index](../README.md) · ➡️ [5.2 Simple Programming Examples](16-beag-programming.md)

## What are we learning?

Everything so far (gates, adders, MUXes, ROMs, registers, FSMs) comes together here into a **computer**: a machine that follows a **program**. This lesson covers what a computer is, how it runs a program step by step, the two ways of arranging its memory, and the instruction set of the course's own computer, **Ríomhaire beag** ("small computer", or **BEAG**).

### You've already built most of one

In Assignment 3, `calc` ran a fixed sequence of steps. Its parts map straight onto a real computer:

| What you built in Assignment 3 | Its name in a computer |
|---|---|
| `counter4` (steps 0, 1, 2, 3 …) | **Program Counter (PC)**: which step we're on |
| ROM holding the control words | **Program memory**: holds the program |
| Splitter / FSM turning a word into Xsel, Dsel, WE … | **Decoder** (control unit): turns an instruction into control signals |
| Register file + ALU | **Processing unit**: does the work |

---

## 1. What is a computer?

From the Oxford Dictionary of Computing (slide 2), a computer is a device that:
- carries out a **sequence of operations** in a clearly defined way;
- the operations are usually **calculations or data handling**, plus **input/output**;
- the sequence can **depend on the data values** (it can make decisions);
- the definition of the sequence is the **program**, stored in **RAM** (changeable) or **ROM** (fixed).

## 2. Stored-program control

Following a program is older than electronics:

| Machine | How it followed a program |
|---|---|
| **Jacquard loom** (1804) | A chain of **punched cards**. Each card was one row of the woven pattern. |
| **Harvard Mark I** (1944, built from relays and shafts) | Read instructions one at a time from **punched paper tape**: do one, read the next. A separate tape could hold the numbers. |
| **Modern computer** | Keeps the program in **memory, as numbers**, like data. |

The modern loop (slide 7):

```
          ┌──────── +1 ────────┐
          ▼                    │
    ┌─────────┐ address  ┌─────────┐ instruction ┌─────────┐
    │ Program │ ───────► │ Program │ ──────────► │ Decoder │ ──► control signals
    │ Counter │          │ Memory  │             └─────────┘
    └─────────┘          └─────────┘
         ▲
       Clock
```

On every clock tick, the PC points at an instruction, memory returns it, the decoder turns it into control signals, and the PC moves on (+1).

## 3. Instruction Set Architecture vs organisation

| | **Instruction Set Architecture (ISA)** | **Organisation** |
|---|---|---|
| What it is | What a **programmer** needs to know to write machine code | How the **hardware** carries out the ISA |
| Includes | the instructions and how each is encoded as a number; the registers; how programs reach memory and I/O | which units the computer is built from and how they're wired |
| Analogy | a car's **controls** (pedals, wheel, gear stick) | the **engine** under the bonnet |

The **same ISA can have different organisations**: Intel and AMD build their processors differently, but both run the same x86 programs.

## 4. Von Neumann and Harvard architectures

Every stored-program computer has:
- a **processing unit**: the ALU and the registers;
- a **control unit**, with the **program counter**, which fetches and decodes instructions;
- **memory**;
- **input and output** devices (display, keyboard, storage).

They differ in **where the program lives**:

| | **Harvard** | **Von Neumann** |
|---|---|---|
| Memory | **two separate** memories: program and data | **one** memory for both |
| Named after | the Harvard Mark I (program on its own tape) | John von Neumann |
| BEAG circuit | `beag_harward.circ` | `beag_von_neumann.circ` |
| Clock cycles per BEAG instruction | **1** | **2**: fetch, then execute |

**Why two cycles for von Neumann?** With one memory, the computer can't read the instruction *and* read or write data at the same moment. So it **fetches** the instruction into an **instruction register (IR)** in one cycle, then **executes** it in the next (which may use the same memory for data).

## 5. The instruction cycle: fetch, decode, execute

A CPU runs a program by repeating three steps for every instruction. For `add r3, r1, r2` (r3 = r1 + r2):

1. **Fetch:** the PC holds the address of the instruction, and program memory returns the instruction stored there.
2. **Decode:** the control unit turns the instruction into **control signals**, which set up the other units for this instruction.
3. **Execute:** the units do the work:
   - the register file reads r1 and r2;
   - the ALU adds them;
   - the register file writes the sum into r3, and the PC moves on to the next instruction.

After a **reset** the PC holds a fixed start address (**0** on the BEAG), and the cycle repeats for as long as the clock runs.

---

## 6. The BEAG instruction set architecture

| Feature | BEAG |
|---|---|
| Data | **16-bit** |
| Instructions | **16-bit** (one memory word each) |
| Registers | **8**: r0 … r7. **r0 always contains 0.** So 7 registers (r1–r7) hold data. |
| Addresses | **16-bit** for both program and data |
| Display | **write** a character's ASCII code to address **0x4000** |
| Keyboard | address **0x4001** reads **1** if a key is waiting; the key's code is at **0x4002** |

### The instructions (slide 18)

| Instruction | Meaning |
|---|---|
| `lli reg, value` | reg ← value (8 bits, **sign-extended** to 16) |
| `lhi reg, value` | the **top 8 bits** of reg ← value |
| `lw reg, (rega)` | reg ← memory[rega] (**load word**) |
| `sw reg, (rega)` | memory[rega] ← reg (**store word**) |
| `add reg, regs1, regs2` | reg ← regs1 + regs2 |
| `sub reg, regs1, regs2` | reg ← regs1 − regs2 |
| `mul reg, regs1, regs2` | reg ← regs1 × regs2 |
| `div reg, regs1, regs2` | reg ← regs1 ÷ regs2 |
| `rem reg, regs1, regs2` | reg ← remainder of regs1 ÷ regs2 |
| `bz reg, offset` | if reg = 0: PC ← PC + offset; otherwise PC ← PC + 1 |
| `bnz reg, offset` | like bz, but jumps if reg ≠ 0 |
| `bltz reg, offset` | like bz, but jumps if reg < 0 |
| `jalr reg, regs1, regs2` | reg ← PC + 1, then PC ← regs1 + regs2 (jump, and remember where to come back to) |

### Register encoding

| Register | r0 | r1 | r2 | r3 | r4 | r5 | r6 | r7 |
|---|---|---|---|---|---|---|---|---|
| Code | 000 | 001 | 010 | 011 | 100 | 101 | 110 | 111 |

Eight registers need 3 bits, but each register **field** in an instruction is **4 bits**: a **0** followed by the 3-bit code. That's handy, because each field is then exactly **one hex digit**: r3 is just `3`.

### Instruction encoding (slide 20)

Every instruction is 16 bits, split into four 4-bit fields:

| Instruction | OpCode [15:12] | Field 1 [11:8] | Field 2 [7:4] | Field 3 [3:0] |
|---|---|---|---|---|
| `add rd,rx,ry` | 0000 (**0**) | rd | rx | ry |
| `sub rd,rx,ry` | 0001 (**1**) | rd | rx | ry |
| `mul rd,rx,ry` | 0010 (**2**) | rd | rx | ry |
| `div rd,rx,ry` | 0011 (**3**) | rd | rx | ry |
| `jalr rd,rx,ry` | 0100 (**4**) | rd | rx | ry |
| `sw reg,(rega)` | 0101 (**5**) | 0000 | rega | reg |
| `lw reg,(rega)` | 0110 (**6**) | reg | rega | 0000 |
| `rem rd,rx,ry` | 0111 (**7**) | rd | rx | ry |
| `lhi reg,value` | 1000 (**8**) | reg | 8-bit value | |
| `lli reg,value` | 1001 (**9**) | reg | 8-bit value | |
| `bnz reg,offset` | 1101 (**D**) | reg | 8-bit signed offset | |
| `bz reg,offset` | 1110 (**E**) | reg | 8-bit signed offset | |
| `bltz reg,offset` | 1111 (**F**) | reg | 8-bit signed offset | |

> 💡 Because every field is 4 bits, you can encode most instructions **straight into hex, one digit per field**, without writing the binary.

---

## Worked examples: encoding and decoding

**Encode `add r3, r2, r1`**
- add = **0**, rd = r3 = **3**, rx = r2 = **2**, ry = r1 = **1**
- Machine code: **0321**

**Encode `lli r1, 3`**
- lli = **9**, reg = r1 = **1**, value = 3 = **03** (8 bits = two hex digits)
- Machine code: **9103**

**Encode `sw r3, (r1)`** (careful: the fields are in a different order)
- sw = **5**, then **0**, then the address register r1 = **1**, then the data register r3 = **3**
- Machine code: **5013**

**Encode `bnz r2, -2`**
- bnz = **D**, reg = **2**, offset −2 as an 8-bit two's complement number:
  2 = 0000 0010 → flip → 1111 1101 → +1 → 1111 1110 = **FE**
- Machine code: **D2FE**

**Decode `6640`**
- 6 = lw, field 1 = 6 → r6, field 2 = 4 → r4, field 3 = 0 (unused)
- Instruction: **`lw r6, (r4)`**, meaning r6 = memory[r4]

**Decode `E000`**
- E = bz, reg = r0, offset = 0
- `bz r0, 0`: r0 is always 0, so it always jumps by 0, to itself. This is an **infinite loop**, used to **stop** a program.

---

## Common mistakes

- **Mixing up the field order for `sw`.** It's `5 0 rega reg`: the **address** register comes before the **data** register.
- **Forgetting that r0 is always 0.** Writing to r0 does nothing, and reading it always gives 0.
- **Writing a negative offset in plain binary.** Branch offsets and `lli` values are **8-bit two's complement**: −1 is FF, −2 is FE.
- **Confusing ISA and organisation.** The instruction list is the ISA; the wiring of PC, ALU and memory is the organisation.
- **Thinking von Neumann is slower because its parts are slower.** It's slower here because it shares **one memory**, so fetching and executing take separate cycles.

## Quick summary

- A computer follows a **program**: instructions stored in memory **as numbers**.
- **PC → program memory → decoder → control signals**, then the PC moves on.
- **ISA** = what a programmer sees. **Organisation** = how the hardware does it.
- **Harvard**: separate program and data memories (1 cycle per BEAG instruction). **Von Neumann**: one shared memory (2 cycles: fetch, execute).
- BEAG: 16-bit data and instructions, 8 registers (r0 = 0), display at 0x4000, keyboard at 0x4001/0x4002.
- Each instruction is 4 hex digits: **opcode, field 1, field 2, field 3**.

---

## 📝 Quiz

**Q1.** Name the three steps a CPU repeats for every instruction, in order.

<details><summary>Answer</summary>

**Fetch, decode, execute.**
</details>

**Q2.** What's the difference between an ISA and an organisation? Give an example.

<details><summary>Answer</summary>

The **ISA** is what a programmer needs to know (instructions, their encodings, registers, how to reach memory and I/O). The **organisation** is how the hardware carries it out. Example: Intel and AMD processors are organised differently but both run x86 programs.
</details>

**Q3.** Why does the von Neumann BEAG need two clock cycles per instruction, but the Harvard BEAG only one?

<details><summary>Answer</summary>

The von Neumann BEAG has **one memory** for program and data, so it can't fetch an instruction and access data at the same time. It fetches the instruction into the instruction register in one cycle and executes it in the next. The Harvard BEAG has separate memories, so both happen in the same cycle.
</details>

**Q4.** Encode `sub r1, r0, r1` in hex. What does it do?

<details><summary>Answer</summary>

sub = 1, rd = 1, rx = 0, ry = 1 → **0x1101**. It computes r1 = 0 − r1, which **changes the sign** of r1.
</details>

**Q5.** Encode `lw r6, (r2)`.

<details><summary>Answer</summary>

lw = 6, reg = 6, rega = 2, last field 0 → **6620**.
</details>

**Q6.** Encode `sw r2, (r1)`.

<details><summary>Answer</summary>

sw = 5, 0, rega = 1, reg = 2 → **5012**.
</details>

**Q7.** Decode `9205` and `E507`.

<details><summary>Answer</summary>

- 9205: 9 = lli, r2, value 05 → **`lli r2, 5`**
- E507: E = bz, r5, offset 07 → **`bz r5, 7`** (if r5 = 0, jump 7 instructions forward)
</details>

**Q8.** What is the 8-bit offset field for a branch of −10?

<details><summary>Answer</summary>

10 = 0000 1010 → flip → 1111 0101 → +1 → **1111 0110 = F6**. (So `bz r0, -10` is **E0F6**.)
</details>

**Q9.** In Assignment 3's `calc`, which part acted as the program counter and which as the program memory?

<details><summary>Answer</summary>

**counter4** was the program counter (it stepped through 0, 1, 2 …) and the **ROM** of control words was the program memory.
</details>
