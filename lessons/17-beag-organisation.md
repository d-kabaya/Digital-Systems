# Lesson 5.3 — BEAG Computer Organisation in Detail

> Based on lecture slides **5.3 BEAG computer organisation in detail** (COMP20020) and the circuits `beag_harward.circ` / `beag_von_neumann.circ`.
> ⬅️ [5.2 Programming the BEAG](16-beag-programming.md) · [Index](../README.md)

## What are we learning?

Lesson 5.1 gave the BEAG's **instruction set** (what a programmer sees). This lesson opens the box and looks at its **organisation**: the units inside, what each one does, and how an instruction flows through them. Almost every unit is something you've already built in an earlier lesson or assignment.

---

## 1. The big picture

```
            ┌─────────────────────── PCsel ──────────────────────┐
            ▼                                                     │
      ┌──────────┐  addr  ┌──────────┐  instr  ┌──────────┐ control signals
 Clk ►│ Program  │ ─────► │ Program  │ ──────► │ Decoder  │ ─► Xsel Ysel Dsel ArithCode
      │ Counter  │        │ Memory   │         └──────────┘    MemR MemW ImmExt SrcSel PCsel
      └──────────┘        └──────────┘
                                         Xsel ┌──────────┐ X ──┬──────────────► Data memory address
                                         Ysel │ Register │     ▼                (MemR / MemW)
                                         Dsel │   File   │   ┌─────┐  result   Y = data to store
                                              │          │──►│ ALU │──────┐
                                              └──────────┘ Y └─────┘      │
                                                   ▲  write data          │
                                                   └──────── MUX ◄────────┘ ALU result,
                                                            (SrcSel)         memory data,
                                                                             immediate, PC+1
```

## 2. The units, one by one

### Program Counter (PC)

- **Resets to zero.**
- Holds the address of the instruction being executed.
- Changes on the **rising edge of the clock**.
- A 2-bit control signal, **PCsel**, chooses its next value:

| PCsel | Next PC | Used by |
|---|---|---|
| 0 | PC + 1 | ordinary instructions, and branches whose test fails |
| 1 | PC + offset (the sign-extended 8-bit offset) | branches whose test succeeds |
| 2 | the ALU output | `jalr` (jump to rx + ry) |

*(The PCsel values are read from the circuit.)*

> ⚠️ *Slide note:* the PC slide calls the branches "bne, beq, blt". These are old names for **bnz, bz and bltz**.

### Program Memory

A **ROM** holding the machine code of the program. Its address comes from the PC, and its output is the current instruction.

### Decoder (the control unit)

Takes the instruction and outputs the **control signals** that make the rest of the computer carry it out. The slides describe it simply as **a truth table**: for each opcode, it gives the values of every control signal. This is the same job your Assignment 3 control unit did with its ROM, or the gates in Task 4.

| Control signal | Bits | What it chooses |
|---|---|---|
| Xsel | 3 | which register goes to the ALU's X input |
| Ysel | 3 | which register goes to Y |
| Dsel | 3 | which register is written (r0 means "don't write", since r0 ignores writes) |
| ArithCode | 3 | the ALU operation |
| MemR / MemW | 1 each | read / write data memory |
| ImmExt | 1 | lli (1) or lhi (0) behaviour of the immediate unit |
| SrcSel | 2 | where the register's write data comes from |
| PCsel | 2 | how the PC moves on (table above) |

### Register File

- Holds the data being worked on: r0–r7, with r0 fixed at 0.
- Can **read two registers and write one** at the same time: X and Y out, one result in.
- This is the register file you built in Assignment 3 (registers + a decoder for writing + MUXes for reading).

### ALU (Arithmetic and Logic Unit)

- Performs add, subtract, multiply and divide (and remainder), chosen by **ArithCode**.
- Its inputs come from the register file, and its result goes back to the register file.
- This is the ALU you built in Assignment 2. Its **XeqY** and **XltY** flags are also what decide whether a **branch** is taken: `bz` checks "reg = 0", `bltz` checks "reg < 0".

### Load-immediate (extension) unit

Handles the two "load immediate" instructions:

| Instruction | What the unit does | ImmExt |
|---|---|---|
| `lli reg, value` | **sign-extends** the 8-bit value to 16 bits | 1 |
| `lhi reg, value` | **replaces the top 8 bits** of the register's current value (which comes through the ALU) with the 8-bit value, keeping the bottom 8 | 0 |

### Sign extension

To widen a signed 8-bit number to 16 bits, **copy the sign bit (bit 7) into bits 15 to 8**:

| 8-bit value | 16-bit result | Value |
|---|---|---|
| 0011 0010 | 0000 0000 **0011 0010** | +50 (sign bit 0 → fill with 0s) |
| 1111 1110 | 1111 1111 **1111 1110** | −2 (sign bit 1 → fill with 1s) |

Sign extension **keeps both the sign and the value** of a two's complement number. If you filled with 0s instead, 1111 1110 would become 254, not −2.

### Data Memory

- Stores the working data. The **address** is the register file's **X** output, the data to store is its **Y** output, and data read out goes back to a register.
- **RAM** fills only part of the data address range (from 0x2000).
- Addresses **0x4000–0x4002** go to the **display and keyboard** instead of RAM (memory-mapped I/O). In the circuit, **comparators** check whether the address equals 0x4000, 0x4001 or 0x4002, and steer the read or write to the right device.

### The register-write MUX (SrcSel)

The value written into the destination register can come from four places *(read from the circuit)*:

| SrcSel | Write data | Used by |
|---|---|---|
| 0 | ALU result | add, sub, mul, div, rem |
| 1 | data memory | lw |
| 2 | the immediate unit | lli, lhi |
| 3 | PC + 1 | jalr (saves the return address) |

---

## 3. Following instructions through the hardware

**`add r3, r1, r2`** (0x0321)
1. **Fetch:** the PC points at the instruction, and program memory outputs 0321.
2. **Decode:** Xsel = r1, Ysel = r2, ArithCode = add, Dsel = r3, SrcSel = ALU, PCsel = +1.
3. **Execute:** the register file outputs r1 and r2, and the ALU adds them. On the clock edge, the sum is written into r3 and PC = PC + 1.

**`lw r6, (r4)`** (0x6640)
1. Xsel = r4, so the address comes out of the register file (X) and goes to the data memory.
2. MemR = 1, so the memory outputs the word at that address.
3. SrcSel = memory and Dsel = r6, so on the clock edge that word goes into r6. PC = PC + 1.

**`sw r3, (r1)`** (0x5013)
1. Xsel = r1 gives the address, and Ysel = r3 gives the data.
2. MemW = 1, so the data is written to memory (or, if the address is 0x4000, printed on the display).
3. Dsel = r0, so no register changes. PC = PC + 1.

**`bnz r2, -2`** (0xD2FE)
1. Xsel = r2, compared with zero by the ALU.
2. If r2 ≠ 0, PCsel = PC + offset, so PC = PC − 2. Otherwise PCsel = +1.
3. Dsel = r0, so no register changes.

---

## 4. Harvard vs von Neumann, in the circuits

| | `beag_harward.circ` | `beag_von_neumann.circ` |
|---|---|---|
| Memories | separate **Program_ROM** and **Data_RAM** | **one** address space: the ROM (program, and constant data) and the RAM share it |
| Per instruction | **1** clock cycle | **2** clock cycles |
| Extra parts | — | an **instruction register (IR)**, and a **fetch/execute flip-flop** that alternates between the two cycles |
| Memory address | program memory ← PC; data memory ← X | a MUX picks **PC** during **fetch** and **X** during **execute** |

**How the von Neumann BEAG runs one instruction:**
1. **Fetch cycle:** the address MUX sends the PC to memory, and the instruction is stored in the IR.
2. **Execute cycle:** the decoder works from the IR. Memory is now free for `lw`/`sw`, and at the end the PC moves on.

The flip-flop simply toggles fetch → execute → fetch … (an FSM with two states, as in [Lesson 4.3](13-finite-state-machines.md)).

📌 *Additional:* because program and data share one memory in the von Neumann version, a program can use `lw` to read **constant data stored in the ROM**, such as a message to print. The built-in program in `beag_von_neumann.circ` does exactly this to print "Hello World!".

---

## Common mistakes

- **Thinking the decoder is the 3-to-8 decoder from Lesson 2.6.** Here "decoder" means the whole **instruction decoder** (control unit) that makes all the control signals.
- **Filling with 0s when sign-extending a negative number.** Copy the sign bit.
- **Forgetting that `sw` and branches don't write a register.** The decoder makes Dsel = r0 for them.
- **Mixing up the two memory paths in Harvard.** The PC only ever addresses **program** memory; `lw`/`sw` only ever address **data** memory.
- **Assuming every data address is RAM.** 0x4000–0x4002 are the display and keyboard.

## Quick summary

- **PC** (resets to 0; +1, +offset or ALU, chosen by PCsel) → **program memory** → **decoder** → control signals.
- **Register file**: 2 reads, 1 write. **ALU**: the arithmetic, plus the flags that decide branches.
- **Immediate unit**: lli sign-extends, lhi replaces the top byte.
- **Sign extension** copies bit 7 into bits 15–8.
- **Data memory**: RAM from 0x2000, display/keyboard at 0x4000–0x4002.
- **Von Neumann** adds an IR and a fetch/execute flip-flop, so each instruction takes 2 cycles.

---

## 📝 Quiz

**Q1.** What value does the PC hold after a reset?

<details><summary>Answer</summary>

**0**, so the first instruction is always at address 0x0000.
</details>

**Q2.** Sign-extend the 8-bit value 1000 0001 to 16 bits. What number is it?

<details><summary>Answer</summary>

**1111 1111 1000 0001** = 0xFF81 = **−127**.
</details>

**Q3.** How many registers can the register file read at once, and how many can it write?

<details><summary>Answer</summary>

**Two** reads (X and Y) and **one** write.
</details>

**Q4.** For `lw r1, (r5)`, which unit provides the address, and where does the value written into r1 come from?

<details><summary>Answer</summary>

The address is **r5**, read from the register file's X output. The value comes from the **data memory** (SrcSel = memory).
</details>

**Q5.** Which instructions use PCsel = PC + offset, and when?

<details><summary>Answer</summary>

The branches **bz, bnz and bltz**, but only when their test succeeds. Otherwise the PC just goes up by 1.
</details>

**Q6.** What's the difference between what lli and lhi do in the immediate unit?

<details><summary>Answer</summary>

**lli** sign-extends the 8-bit value to a full 16-bit value. **lhi** keeps the register's bottom 8 bits and replaces the top 8 bits with the value.
</details>

**Q7.** Why doesn't `sw r3, (r1)` change any register, even though it goes through the same datapath?

<details><summary>Answer</summary>

The decoder sets **Dsel = r0** for it, and r0 ignores writes. Only the memory (MemW = 1) changes.
</details>

**Q8.** `sw r2, (r1)` runs with r1 = 0x4000 and r2 = 0x0041. What happens?

<details><summary>Answer</summary>

0x4000 is the **display**, so the character **'A'** (0x41) is printed.
</details>

**Q9.** Name the two extra parts the von Neumann BEAG has, and what each one does.

<details><summary>Answer</summary>

- An **instruction register (IR)**: holds the fetched instruction during the execute cycle, because memory is then used for data.
- A **fetch/execute flip-flop**: alternates between the fetch cycle and the execute cycle.
</details>
