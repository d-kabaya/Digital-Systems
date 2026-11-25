# Lesson 5.2 — Programming the BEAG: Simple Examples

> Based on lecture slides **5.2 Computer Systems: Simple programming examples** (COMP20020).
> ⬅️ [5.1 Computer Organisation](15-computer-organisation-intro.md) · [Index](../README.md) · ➡️ [5.3 BEAG Organisation in Detail](17-beag-organisation.md)

## What are we learning?

How to write real programs for the BEAG: loading numbers, doing arithmetic, using memory, printing to the display, reading the keyboard, and making decisions and loops with branches. It ends with the slides' four example programs, each turned into machine code.

> The example programs are in [`programs/`](../programs/), with the assembler that turns them into ROM images.

---

## 1. Loading numbers: `lli` and `lhi`

A number written inside an instruction is called an **immediate value**, because it's *immediately* there in the instruction code.

- **`lli reg, value`** (load low immediate) puts an **8-bit** value into a register, **sign-extended** to 16 bits.
  `lli r1, 25` → r1 = 25
- **`lhi reg, value`** (load high immediate) replaces the **top 8 bits** of the register and keeps the bottom 8.

An instruction only has room for 8 bits of value, so a **16-bit constant takes two instructions**: `lli` for the low byte first, then `lhi` for the high byte.

**Example: load 0x4001 into r2**
```
lli r2, 0x01     ; r2 = 0x0001   (low byte)
lhi r2, 0x40     ; r2 = 0x4001   (top byte replaced)
```

> ⚠️ The order matters: `lli` overwrites **all 16 bits** (sign extension fills the top byte), so it must come **before** `lhi`.

📌 *Additional: sign extension in action.* `lli r1, 0x80` gives r1 = **0xFF80** (−128), not 0x0080, because bit 7 of 0x80 is 1 and gets copied into the top byte. To get 0x0080, follow it with `lhi r1, 0x00`.

## 2. Arithmetic

`add`, `sub`, `mul`, `div` and `rem` all work the same way: take two registers, do the operation, write the result into a third.

`add r3, r1, r2` means **r3 = r1 + r2**.

Some useful tricks from the slides, all relying on **r0 = 0**:

| Instruction | Meaning | Use |
|---|---|---|
| `add r1, r1, r1` | r1 = r1 + r1 | multiply r1 by 2 |
| `add r2, r0, r1` | r2 = 0 + r1 | **copy** r1 into r2 |
| `sub r7, r6, r4` | r7 = r6 − r4 | ordinary subtraction |
| `sub r1, r0, r1` | r1 = 0 − r1 | **change the sign** of r1 |

## 3. Memory: `lw` and `sw`

Think of memory as one big array, `memory[ ]`, indexed by the **address**:

| Instruction | Meaning | Like |
|---|---|---|
| `lw r1, (r2)` | load word | r1 = memory[r2] |
| `sw r1, (r2)` | store word | memory[r2] = r1 |

The register in brackets always holds the **address**. ("Word" is the old name for a binary number held in a register.)

## 4. The memory map

| Addresses | What's there | Notes |
|---|---|---|
| 0x0000 – 0x1FFF | **ROM** | the program (and constant data); can't be overwritten; the first instruction after reset is at **0x0000** |
| 0x2000 – 0x3FFF | **RAM** | variables; can be read and written; erased on reset |
| **0x4000** | **Display** | write an ASCII code here to print it |
| **0x4001** | **Keyboard ready** | reads **1** if a key has been typed, **0** if not |
| **0x4002** | **Keyboard data** | the ASCII code of the typed key |
| everything else | unused | |

Using ordinary load/store addresses to talk to devices like this is called **memory-mapped I/O**.

> ⚠️ *Slide note:* the slides give the RAM range as 0x2000–0x3FFF but also say the RAM has **4096** locations. The RAM in the circuits has 12 address bits, so only **0x2000–0x2FFF** really holds data.

---

## 5. Programming example 1: add 3 and 6

**Algorithm:** load 3 into r1, load 6 into r2, add them into r3.

| Address | Assembly | OpCode | F1 | F2 | F3 | Hex |
|---|---|---|---|---|---|---|
| 0 | `lli r1, 3` | 1001 | 0001 | 0000 0011 | | **9103** |
| 1 | `lli r2, 6` | 1001 | 0010 | 0000 0110 | | **9206** |
| 2 | `add r3, r2, r1` | 0000 | 0011 | 0010 | 0001 | **0321** |

**Running it in Logisim:**
1. Right-click the **ROM** → **Edit Contents…**, and type the hex codes into addresses 0, 1, 2.
2. **Ctrl+R** (Cmd+R on a Mac) to reset, then **Ctrl+T** to tick the clock, one step at a time.
3. In `beag_von_neumann.circ` each instruction takes **two clock cycles (four Ctrl+T presses)**: one to fetch, one to execute.

## 6. Programming example 2: print "Hi"

**Algorithm:** put the display address 0x4000 into r1; put the code for "H" into r2 and store it at (r1); then the same for "i".

| Address | Assembly | Hex | What it does |
|---|---|---|---|
| 0 | `lli r1, 0x00` | 9100 | r1 = 0x0000 |
| 1 | `lhi r1, 0x40` | 8140 | r1 = 0x4000 (the display) |
| 2 | `lli r2, 0x48` | 9248 | r2 = 'H' |
| 3 | `sw r2, (r1)` | 5012 | print 'H' |
| 4 | `lli r2, 0x69` | 9269 | r2 = 'i' |
| 5 | `sw r2, (r1)` | 5012 | print 'i' |

Source: [`programs/hi.asm`](../programs/hi.asm), machine code: [`programs/hi.mem`](../programs/hi.mem).

---

## 7. Branches: decisions and loops

Instructions sit in **consecutive** memory locations. The **PC** holds the address of the next instruction, and normally goes up by 1. A **branch** tests a register and, if the test is true, **adds an offset to the PC** instead:

| Instruction | Jumps if … |
|---|---|
| `bz reg, offset` | reg **= 0** |
| `bnz reg, offset` | reg **≠ 0** |
| `bltz reg, offset` | reg **< 0** |

If the test is false, PC = PC + 1 as usual.

The offset counts **from the branch instruction itself**: `bnz r2, -2` at address 7 jumps to address **5**.

| Example | Meaning |
|---|---|
| `bnz r1, -2` | if r1 ≠ 0, jump 2 instructions back |
| `bltz r1, 12` | if r1 < 0, jump 12 instructions forward |
| `bz r3, -5` | if r3 = 0, jump 5 instructions back |
| `bz r0, -10` | r0 is always 0, so this **always** jumps 10 back: an **unconditional jump** |
| `bz r0, 0` | always jumps to itself: an **infinite loop**, used to **stop** a program |

### Negative offsets in binary

Offsets (and `lli` values) can be negative. They're stored in **8-bit two's complement**:
1. Write the size in binary: 2 → 0000 0010
2. Flip every bit: → 1111 1101
3. Add 1: → **1111 1110** = FE, which is −2

## 8. Programming example 3: print five asterisks

**Algorithm:**
1. r1 = 0x4000 (display), using `lli` + `lhi`
2. r2 = 5 (the counter)
3. r3 = 0x2A (the ASCII code of `*`)
4. r4 = 1
5. Print the `*`
6. r2 = r2 − 1
7. If r2 ≠ 0, jump back 2 instructions (to step 5)
8. Done, so loop forever

| Address | Assembly | Hex |
|---|---|---|
| 0 | `lli r1, 0x00` | 9100 |
| 1 | `lhi r1, 0x40` | 8140 |
| 2 | `lli r2, 5` | 9205 |
| 3 | `lli r3, 0x2A` | 932A |
| 4 | `lli r4, 1` | 9401 |
| 5 | `sw r3, (r1)` | 5013 |
| 6 | `sub r2, r2, r4` | 1224 |
| 7 | `bnz r2, -2` | D2FE |
| 8 | `bz r0, 0` | E000 |

**Trace of the loop:**

| Pass | Prints | r2 after `sub` | `bnz` at address 7 |
|---|---|---|---|
| 1 | `*` | 4 | ≠ 0 → back to 5 |
| 2 | `*` | 3 | back to 5 |
| 3 | `*` | 2 | back to 5 |
| 4 | `*` | 1 | back to 5 |
| 5 | `*` | 0 | = 0 → carry on to 8 (stop) |

Output: `*****`. Source: [`programs/five_asterisks.asm`](../programs/five_asterisks.asm), machine code: [`programs/five_asterisks.mem`](../programs/five_asterisks.mem).

---

## 9. Comparing two numbers

Branches only compare a register with **zero**. To compare r1 with r2, **subtract first**, then test the difference:

| Want | Test |
|---|---|
| r1 = r2 | (r1 − r2) = 0 → `bz` |
| r1 ≠ r2 | (r1 − r2) ≠ 0 → `bnz` |
| r1 < r2 | (r1 − r2) < 0 → `bltz` |

```
sub  r3, r1, r2     ; r3 = r1 - r2
bltz r3, ...        ; jump if r1 < r2
```

📌 *Additional:* this is the same idea as the XltY flag in Assignment 2, and has the same weakness: if r1 and r2 have opposite signs, the subtraction can **overflow** and give the wrong sign.

## 10. If-then-else

An if-then-else needs a **conditional branch** (to choose a part) and an **unconditional branch** `bz r0, …` (to jump over the part you didn't choose).

```c
if (r2 < 0) { r1 = r1 + 1; }    // then part
else        { r1 = r1 - 1; }    // else part
```

| Address | Assembly | Notes |
|---|---|---|
| 0 | `bltz r2, 4` | r2 < 0? jump to the **then** part at 4 |
| 1 | `lli r5, 1` | **else** part … |
| 2 | `sub r1, r1, r5` | … r1 = r1 − 1 |
| 3 | `bz r0, 3` | jump over the then part, to 6 |
| 4 | `lli r5, 1` | **then** part … |
| 5 | `add r1, r1, r5` | … r1 = r1 + 1 |
| 6 | … | both paths continue here |

> ⚠️ *Slide note:* the slide's version uses r3 instead of r1, and puts the `add` straight after the `bltz`. Since `bltz` *jumps away* when r2 < 0, the instructions straight after it run when r2 is **not** negative, so they must be the **else** part (the `sub`). The table above has them the right way round, and it's been checked by simulation.

---

## 11. Programming example 4: the backwards printer

Read what the user types until they press **Enter**, then print it **backwards** (`Curiosity` → `ytisoiruC`). The typed characters are too many for 7 registers, so they're stored in **RAM**, starting at 0x2000.

**The idea:** store the characters one after another in RAM, counting them. Then walk back through RAM, printing each one.

**The registers:**

| Register | Holds |
|---|---|
| r1 | 0x4000 (display) |
| r2 | 0x4001 (keyboard ready) |
| r3 | 0x4002 (keyboard data) |
| r4 | the RAM pointer, starting at 0x2000 |
| r5 | how many characters have been typed |
| r6, r7 | scratch values |

**The program** (from `programs/back3.asm`, which uses labels):

```
    li   r1,0x4000  ; display address        (li = lli + lhi)
    li   r2,0x4001  ; keyboard ready
    li   r3,0x4002  ; keyboard data
    li   r4,0x2000  ; start of RAM
    lli  r5,0       ; length of the string = 0
read:
    lw   r6,(r2)    ; has a key been typed?
    bz   r6,read    ; no: keep checking (polling)
    lw   r6,(r3)    ; yes: read its code
    lli  r7,0x0A
    sub  r7,r7,r6   ; is it Enter (0x0A)?
    bz   r7,print   ; yes: go and print
    sw   r6,(r4)    ; no: save it in RAM
    lli  r7,1
    add  r5,r5,r7   ; length + 1
    add  r4,r4,r7   ; pointer + 1
    bz   r0,read    ; wait for the next key
print:
    bz   r5,halt    ; nothing left? stop
    lli  r7,1
    sub  r5,r5,r7   ; length - 1
    sub  r4,r4,r7   ; pointer back one
    lw   r6,(r4)    ; get that character
    sw   r6,(r1)    ; print it
    bz   r0,print   ; and repeat
halt:
    bz   r0,halt    ; loop forever
```

It assembles to the same 28 words as the slides (9100 8140 9201 … E0FA E000): [`programs/backwards_printer.mem`](../programs/backwards_printer.mem).

**Tracing "Hi" + Enter:**
- Reading: 'H' (0x48) is stored at 0x2000, then 'i' (0x69) at 0x2001. Now r5 = 2 and r4 = 0x2002.
- Printing: r4 → 0x2001, print 'i'; r4 → 0x2000, print 'H'; r5 = 0, so stop.
- Output: **iH** ✓

### Why the pointer goes up *after* storing but down *before* loading

r4 always points to the **next free** slot. So when storing you write first, then move on; when printing you have to step back first, to reach the last character actually stored.

---

## 12. Labels instead of counting offsets

The [`programs/`](../programs/) folder has the backwards printer written three ways:

| File | Style |
|---|---|
| `back1.asm` | exactly as on the slides: **numeric offsets**, like `bz r6,-1` |
| `back2.asm` | **labels** for the loops (`read:`, `print:`), but one numeric offset left |
| `back3.asm` | labels everywhere, the `li` shortcut, and comments |

With a label, the **assembler** works out the offset for you, so adding or removing an instruction doesn't break your jumps. All three produce identical machine code. See [`programs/README.md`](../programs/README.md) for how to run the assembler.

---

## Common mistakes

- **Putting `lhi` before `lli`.** `lli` overwrites the whole register, so the high byte you set is lost.
- **Counting offsets from the wrong place.** The offset is added to the **branch's own address**, not the next one.
- **Forgetting the stop loop** (`bz r0, 0`). Without it, the PC runs off the end of your program into whatever is in the ROM after it.
- **Writing `sw r1, (r2)` when you mean the opposite.** The register in brackets is always the **address**.
- **Using `bz` to test "less than".** Use `bltz` on the difference.
- **Reading the keyboard data without checking 0x4001 first.** You'd read the same key again, or nothing.

## Quick summary

- 16-bit constant = `lli` (low byte) **then** `lhi` (high byte).
- `lw r, (a)`: r = memory[a]. `sw r, (a)`: memory[a] = r.
- Memory map: ROM 0x0000, RAM 0x2000, display 0x4000, keyboard ready 0x4001, key code 0x4002.
- Branch: if the test is true, **PC = PC + offset**; otherwise PC + 1. `bz r0, n` always jumps; `bz r0, 0` stops.
- Compare two numbers by **subtracting** and testing the result.
- if-then-else = conditional branch + unconditional branch over the other part.

---

## 📝 Quiz

**Q1.** Write the two instructions that put 0x2000 into r4, and give their machine code.

<details><summary>Answer</summary>

`lli r4, 0x00` = **9400**, then `lhi r4, 0x20` = **8420**.
</details>

**Q2.** What value is in r1 after `lli r1, -1`? Give it in hex and in decimal.

<details><summary>Answer</summary>

−1 is 0xFF as 8 bits, and sign extension fills the top byte with 1s: r1 = **0xFFFF = −1**.
</details>

**Q3.** Write one instruction that copies r5 into r6.

<details><summary>Answer</summary>

`add r6, r0, r5` (r6 = 0 + r5). Machine code **0605**.
</details>

**Q4.** What do `lw r6, (r2)` and `sw r6, (r1)` do in the backwards printer?

<details><summary>Answer</summary>

`lw r6, (r2)` reads address 0x4001, the **keyboard-ready flag**. `sw r6, (r1)` writes r6 to 0x4000, which **prints** that character on the display.
</details>

**Q5.** A `bz r5, 7` instruction is at address 0x14. Where does it jump if r5 = 0? And if r5 = 3?

<details><summary>Answer</summary>

r5 = 0: PC = 0x14 + 7 = **0x1B**. r5 = 3: the test fails, so PC = **0x15**.
</details>

**Q6.** Encode `bz r0, -6`.

<details><summary>Answer</summary>

6 = 0000 0110 → flip → 1111 1001 → +1 → 1111 1010 = FA. So **E0FA**.
</details>

**Q7.** Change the asterisk program so that it prints **eight** asterisks. Which one instruction changes, and what's its new machine code?

<details><summary>Answer</summary>

`lli r2, 5` becomes `lli r2, 8`: **9208**.
</details>

**Q8.** Write instructions that jump to a label `smaller` if r1 < r2 (use r3 as scratch).

<details><summary>Answer</summary>

```
sub  r3, r1, r2
bltz r3, smaller
```
</details>

**Q9.** In the backwards printer, why does `sub r4, r4, r7` come **before** `lw r6, (r4)` in the printing loop?

<details><summary>Answer</summary>

After reading, r4 points to the **next free** RAM slot, one past the last character. It has to step back first to reach a character that was actually stored.
</details>

**Q10.** What happens if a program has no `bz r0, 0` at the end?

<details><summary>Answer</summary>

The PC keeps going into the rest of the ROM and runs whatever is there (often 0000 = `add r0,r0,r0`, which does nothing), so the computer never "stops" in a controlled way.
</details>
