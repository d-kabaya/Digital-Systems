# Lesson 4.2 — Basic Synchronous Sequential Circuits

> Based on lecture slides **4.2 Basic synchronous sequential logic circuits** (COMP20020).
> ⬅️ [4.1 Latches & Flip-Flops](11-latches-and-flip-flops.md) · [Index](../README.md) · ➡️ [4.3 Finite State Machines](13-finite-state-machines.md)

## What are we learning?

Now that we have flip-flops, we can combine them into the standard building blocks of a computer's memory side: **registers**, **RAM**, **counters** and **shift registers**. All of them are **synchronous**, meaning they're driven by one shared clock.

Logisim file for this lesson: [`ram_idea.circ`](../circuits/ram_idea.circ).

---

## 1. Synchronous vs asynchronous

A sequential circuit is **synchronous** if:

1. every element is either a flip-flop or a combinational circuit,
2. there's at least one flip-flop,
3. **all flip-flops receive the same clock**, and
4. **every loop (cyclic path) goes through at least one flip-flop.**

Anything else is **asynchronous**. Almost all real designs are synchronous, because it makes them **much easier to design**: everything changes at the same predictable moment, the clock edge.

> 💡 Rule 4 matters because a loop with no flip-flop in it is a latch-style feedback loop. Its value could change at any moment instead of on the clock.

## 2. Registers

> "A register is a group of flip-flops which store one word of data."

A 4-bit register is simply **4 D flip-flops side by side**, all sharing one clock. On each rising edge, all 4 bits of input X are copied into Q **at the same time**.

### Multi-bit timing diagrams

For buses, the timing diagram shows the **value** in each interval instead of a high/low line:

```
CLK:  _|‾|_|‾|_|‾|_|‾|_
X:    0011 | 1000 | 1010 | 1100
Q:    0000 | 0011 | 1000 | 1010
```

Q always shows the value X had at the **previous** rising edge. The register delays the data by one clock cycle.

### Resets: giving flip-flops a known starting value

When the power comes on, a flip-flop holds an **unknown** value (shown as **x** in simulation). So circuits need a **reset**:

| | Synchronous reset | Asynchronous reset |
|---|---|---|
| When it acts | on the next **clock edge** | **immediately**, without waiting for the clock |
| Glitch risk | safe | **susceptible to glitches**: a spike on RESET clears the flip-flop |
| Typical form | often **active-low** (RESET = 0 means reset) | often active-high |
| How common | **most circuits** | used sometimes |

## 3. Random Access Memory (RAM)

RAM is organised as a **grid**, like ROM ([Lesson 2.6](07-building-blocks.md)), but each cell holds a **changeable** memory element instead of a fixed transistor.

| | ROM | RAM |
|---|---|---|
| Can you change the contents? | no | **yes** |
| Inputs | address | address + **data in** + **Write Enable** |
| On power-off | keeps its data | **volatile**: data is lost |
| On power-on | known contents | **random**, so it must be initialised by software |

- **Write Enable (WE)** is the control signal that allows the selected word to be overwritten.
- Many RAM chips use one shared **data port** for both reading and writing.

### Static vs dynamic RAM

- **Static RAM (SRAM):** each bit is a **6-transistor cell**. The core is two inverters in a loop, the same bistable idea as Lesson 4.1. A **word line (WL)** selects the cell, and **bit lines (BL and BL̄)** read or write it. It's fast, but large.
- **Dynamic RAM (DRAM):** each bit is **one transistor + one tiny capacitor**. A charged capacitor means 1. It's **much smaller**, but the charge leaks away, so DRAM must be **refreshed many times per second**. This links back to the capacitors in [Lesson 1.3](03-logic-gates.md).

Your [`ram_idea.circ`](../circuits/ram_idea.circ) builds a small RAM grid out of **D-latch cells**, with an address decoder selecting the word and a Write Enable. Its notes point out that real RAM powers up with random contents, while Logisim's RAM component always starts filled with 0s.

## 4. Frequency dividers and counters

### Frequency divider

Take a **JK flip-flop with J = K = 1** (toggle mode). It flips on every rising clock edge, so its output Q completes one full cycle for every **two** clock cycles:

```
f_out = f_clock / 2       (period doubles: T → 2T)
```

Chain more of them and you divide by 4, 8, 16, …

### Asynchronous ("ripple") counter

Chain toggling flip-flops so that **each one's output clocks the next**. The bits count up in binary: Q₁Q₀ = 00, 01, 10, 11, 00…

The problem is that each flip-flop waits for the previous one to change, so the change **ripples** through with a growing delay. This breaks rule 3 above (not all flip-flops share the same clock), so it's **asynchronous**.

### Synchronous counter

**All flip-flops share the same clock.** Each bit just has to decide *whether to toggle* on the next edge:

- Bit 0 toggles **every** edge (J₀ = K₀ = 1).
- Bit 1 toggles when **Q₀ = 1**.
- Bit 2 toggles when **Q₀·Q₁ = 1** (an AND gate).
- Bit 3 toggles when **Q₀·Q₁·Q₂ = 1**, and so on.

**Rule:** a bit toggles when **all the bits below it are 1**. That's exactly how binary counting works: 0111 + 1 = 1000.

A 3-bit counter goes 000 → 001 → … → 111 → 000 (it **recycles** after 8 pulses).

## 5. Shift registers: parallel ↔ serial

**Serial communication** sends data **one bit at a time**, for example down an optical fibre. But the ALU produces whole words **in parallel**. So you need a way to convert between the two:

- **Parallel-In Serial-Out (PISO):** load a whole word at once, then shift it out one bit per clock. Used for **sending**.
- **Serial-In Parallel-Out (SIPO):** feed bits in one per clock. They shift along the chain of flip-flops (Q₃ → Q₂ → Q₁ → Q₀), and after *n* clocks the whole word is available on the parallel outputs. Used for **receiving**.

A shift register is just D flip-flops in a chain, where **each one's Q feeds the next one's D**, all on the same clock.

---

## Common mistakes

- Expecting a register's Q to change the moment X changes. It only updates on the **clock edge**, so it's one cycle behind.
- Calling a ripple counter synchronous. Its flip-flops **don't share a clock**.
- Thinking RAM keeps its data without power. It's **volatile**.
- Mixing up SRAM (6 transistors, fast, big) and DRAM (1 transistor + capacitor, small, needs refreshing).

## Quick summary

- Synchronous means one shared clock, and every loop passes through a flip-flop.
- A register is n D flip-flops sharing a clock. Use a reset to give it a known starting value.
- RAM is a writable, volatile grid (SRAM or DRAM).
- A toggle flip-flop divides the frequency by 2. In a synchronous counter, a bit toggles when all lower bits are 1.
- Shift registers convert between parallel and serial (PISO, SIPO).

---

## 📝 Quiz

**Q1.** List the four conditions for a circuit to be synchronous.

<details><summary>Answer</summary>

1. Every element is a flip-flop or combinational logic.
2. There's at least one flip-flop.
3. All flip-flops share the same clock.
4. Every cyclic path contains a flip-flop.
</details>

**Q2.** A 4-bit register has X = 0101 before a rising edge and X = 1111 just after it. What does Q hold right after that edge?

<details><summary>Answer</summary>

**0101.** The register captures the value present **at** the edge.
</details>

**Q3.** What is the difference between a synchronous and an asynchronous reset?

<details><summary>Answer</summary>

A **synchronous** reset takes effect on the next clock edge. An **asynchronous** reset acts immediately, without the clock, which makes it susceptible to glitches.
</details>

**Q4.** Give two differences between RAM and ROM.

<details><summary>Answer</summary>

RAM can be **written** (it has a data input and Write Enable). It's also **volatile**, so its contents are lost without power and are random at power-up. ROM is fixed and keeps its contents.
</details>

**Q5.** Why does DRAM need refreshing but SRAM doesn't?

<details><summary>Answer</summary>

DRAM stores each bit as charge on a tiny **capacitor**, which **leaks** away. SRAM stores each bit in a loop of inverters (bistable), which holds its value as long as there's power.
</details>

**Q6.** An 8 MHz clock drives two toggling JK flip-flops in a chain (the second is clocked by the first's Q). What frequency comes out of the second flip-flop?

<details><summary>Answer</summary>

Each stage divides by 2: 8 → 4 → **2 MHz**.
</details>

**Q7.** In a synchronous 4-bit counter, when does bit Q₂ toggle?

<details><summary>Answer</summary>

When **Q₁ = 1 and Q₀ = 1** (J₂ = K₂ = Q₀·Q₁), i.e. when all the lower bits are 1.
</details>

**Q8.** A 3-bit synchronous counter starts at 000. What is its value after 10 clock pulses?

<details><summary>Answer</summary>

It counts modulo 8: 10 mod 8 = 2, so the value is **010**.
</details>

**Q9.** Which kind of shift register would you use at the **receiving** end of a serial link, and how many clocks does it need to collect a 4-bit word?

<details><summary>Answer</summary>

**Serial-In Parallel-Out (SIPO)**. It needs **4 clocks**, one per bit.
</details>
