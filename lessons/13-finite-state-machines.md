# Lesson 4.3 — Finite State Machines (FSMs)

> Based on lecture slides **4.3 Finite State Machines** (COMP20020).
> ⬅️ [4.2 Synchronous Circuits](12-synchronous-circuits.md) · [Index](../README.md) · ➡️ [4.4 FSM Timing](14-fsm-timing.md)

## What are we learning?

A **finite state machine** is the general recipe for designing *any* synchronous circuit: counters, sequence generators, and the controllers that run step-by-step algorithms in hardware. This lesson covers the design process, then works through both examples from the slides:

1. A sequence generator: [`fsm_example.circ`](../circuits/fsm_example.circ).
2. A hexadecimal code printer controller: [`hex_code_printer.circ`](../circuits/hex_code_printer.circ).

---

## 1. What "state" means

> "The **state** of a sequential circuit is the value currently stored in its memory."

> "A **Finite State Machine** is a logic circuit which exhibits a sequence of states and is controlled by internal logic and, optionally, also by external inputs."

"Finite" means there are a fixed, limited number of states. With *n* flip-flops there are at most 2ⁿ.

## 2. The structure of every FSM

```
            ┌──────────────┐ Y  ┌────────┐  Q (state)  ┌──────────────┐
 Input I ──►│ Next-state   │───►│ Memory │───────┬────►│ Output logic │──► Output O
            │ logic (comb.)│    │ (flip- │       │     │   (comb.)    │
            └──────▲───────┘    │ flops) │       │     └──────────────┘
                   │            └───▲────┘       │
                   └────────────────┼────────────┘
                                  Clock
```

- **Memory** (flip-flops) holds the current state Q.
- **Next-state logic** (combinational) works out what the state should be after the next clock edge, from Q and the input I. Its output Y is called the **excitation**, because it drives the flip-flops' D inputs.
- **Output logic** (combinational) works out the outputs.

So an FSM is just **combinational logic plus flip-flops**, which is everything from the earlier lessons put together.

## 3. Moore vs Mealy

| | Moore machine | Mealy machine |
|---|---|---|
| Outputs depend on | the **current state only** | the current state **and the current inputs** |
| In a state diagram, outputs are written | inside the state | on the arrows ("input / outputs") |
| An FSM with no inputs | is always Moore | — |

## 4. The FSM design process (8 steps)

1. Draw the **state diagram**.
2. Write the **state transition table** (current state → next state).
3. Work out **how many flip-flops** you need: ⌈log₂(number of states)⌉.
4. Choose the **state encoding** (a binary code for each state), and update steps 1 and 2 to use it.
5. Choose the **type of flip-flop**. D is the easiest.
6. Write the **flip-flop transition table** (which inputs each flip-flop needs).
7. Find the **next-state logic** (current state → D inputs).
8. Find the **output logic** (current state → outputs).

With **D flip-flops**, step 6 is free: the next state is simply whatever you put on D, so **D = next state**.

---

## 5. Design example 1: a sequence generator {1, 2, 5, 7}

**Task:** generate the repeating sequence 1, 2, 5, 7 (in binary: 001, 010, 101, 111). There are no inputs except the clock.

**Steps 1–4.** There are no inputs, so this is a **Moore** machine. There are 4 states, so you need **2 flip-flops** (Q₁Q₀). Encode the states as 00, 01, 10, 11 and have them count in order:

```
 00 ──► 01 ──► 10 ──► 11
  ▲                    │
  └────────────────────┘
```

**Step 7: next-state logic** (D = next state):

| Q₁Q₀ | D₁D₀ |
|---|---|
| 00 | 01 |
| 01 | 10 |
| 10 | 11 |
| 11 | 00 |

- D₀ is 1 in rows 00 and 10, i.e. whenever Q₀ = 0. So **D₀ = Q̄₀**.
- D₁ is 1 in rows 01 and 10, i.e. whenever Q₁ and Q₀ differ. So **D₁ = Q₁ ⊕ Q₀**.

**Step 8: output logic.** Map each state to its output:

| Q₁Q₀ | O₂O₁O₀ |
|---|---|
| 00 | 001 (1) |
| 01 | 010 (2) |
| 10 | 101 (5) |
| 11 | 111 (7) |

- **O₂ = Q₁** (it's 1 in rows 10 and 11).
- **O₁ = Q₀** (it's 1 in rows 01 and 11).
- **O₀ = Q₁ + Q̄₀** (it's 0 only in row 01).

Your [`fsm_example.circ`](../circuits/fsm_example.circ) is exactly this circuit: two D flip-flops (D0 fed from its own Q̄, D1 fed from an XOR), an OR gate for O₀, and a power-on reset so it starts in 00.

### Pop quiz from the slides: a counter for {00, 11, 01, 10}

Here the output **is** the state, so O₁ = Q₁ and O₀ = Q₀. The transitions are 00 → 11 → 01 → 10 → 00:

| Q₁Q₀ | D₁D₀ |
|---|---|
| 00 | 11 |
| 11 | 01 |
| 01 | 10 |
| 10 | 00 |

- **D₁ = Q̄₁** (D₁ is 1 exactly when Q₁ = 0).
- **D₀ = (Q₁ ⊕ Q₀)̅**, i.e. XNOR (D₀ is 1 exactly when Q₁ = Q₀).

---

## 6. FSMs as controllers: datapath + control

FSMs are used to run **multi-step algorithms in hardware**. The system is split into two parts:

- The **datapath** contains the functional units that do the work: registers, ROMs, MUXes, the display.
- The **control logic** (the FSM) reads **information signals** from the datapath (its inputs) and sends **control signals** back (its outputs), step by step.

```
Input data ──► [ Datapath ] ──► Output data
                 │      ▲
   information   │      │   control
   signals       ▼      │   signals
               [ FSM controller ]
```

## 7. Design example 2: hexadecimal code printer

**Task:** when a key is pressed, print its ASCII code as **two hex digits followed by a space**. For example, the newline key (0x0A) prints "0A ".

### The datapath ([`hex_code_printer.circ`](../circuits/hex_code_printer.circ))

- **Keyboard → bit extender → 8-bit register.** The 7-bit ASCII code is padded to 8 bits and stored in the register when **read = 1**.
- **Splitter + 4-bit MUX.** This picks the **high nibble** (sel_nibble = 1) or the **low nibble** (sel_nibble = 0) of the stored code.
- **ROM.** It converts a 4-bit value (0–F) into the ASCII code of that hex digit ('0' = 0x30 … 'F' = 0x46). This is a ROM used as a decoder, as in [Lesson 2.6](07-building-blocks.md).
- **8-bit MUX.** It chooses between the ROM's digit (blank_sel = 0) and a space character, 0x20 (blank_sel = 1).
- **TTY display.** It prints the character on the clock edge when **wr_en = 1**.

### The signals

| Signal | Direction | Meaning |
|---|---|---|
| rdy | datapath → FSM (**input**) | 1 means a key is waiting in the keyboard buffer |
| read | FSM → datapath | store the key code in the register and remove it from the buffer |
| sel_nibble | FSM → datapath | 1 = high nibble, 0 = low nibble |
| blank_sel | FSM → datapath | 1 = print a space instead of a digit |
| wr_en | FSM → datapath | 1 = print on this clock edge |

### The algorithm and its states

Each action becomes one state:

| State | Encoding | What happens |
|---|---|---|
| S0 | 00 | wait for a key. If rdy = 1, set read = 1 and go to S1 |
| S1 | 01 | print the high nibble (sel_nibble = 1, wr_en = 1) |
| S2 | 10 | print the low nibble (sel_nibble = 0, wr_en = 1) |
| S3 | 11 | print a space (blank_sel = 1, wr_en = 1), then go back to S0 |

**read** depends on both the state (S0) **and** the input rdy, so this is a **Mealy** machine.

"x" in the tables below means **don't care**. In S0 nothing is printed, so sel_nibble and blank_sel don't matter. In S3 a space is printed, so sel_nibble doesn't matter. Don't-cares help simplify the logic, just like in K-maps ([Lesson 2.3](05-karnaugh-maps.md)).

### Next-state logic

| Q₁Q₀ | rdy | D₁D₀ |
|---|---|---|
| 00 | 0 | 00 |
| 00 | 1 | 01 |
| 01 | x | 10 |
| 10 | x | 11 |
| 11 | x | 00 |

- **D₁ = Q₁ ⊕ Q₀**
- **D₀ = Q̄₀ · (Q₁ + rdy)**

### Output logic

| Q₁Q₀ | rdy | read | sel_nibble | blank_sel | wr_en |
|---|---|---|---|---|---|
| 00 | 0 | 0 | x | x | 0 |
| 00 | 1 | **1** | x | x | 0 |
| 01 | x | 0 | 1 | 0 | 1 |
| 10 | x | 0 | 0 | 0 | 1 |
| 11 | x | 0 | x | 1 | 1 |

- **read = rdy · Q̄₁ · Q̄₀**
- **sel_nibble = Q₀** (the don't-cares allow this)
- **blank_sel = Q₁ · Q₀**
- **wr_en = Q₁ + Q₀**

> **Could it be a Moore machine?** *(Explanation added here; the slides leave it as a question.)* Yes. Add an extra state between S0 and S1 whose only job is to output read = 1. Then every output depends only on the state. The cost is one more state and one more clock cycle per key.

> ⚠️ *Slide typo: on the "Summary of signals" slide, the blank_sel description ends with "(sel_nibble == 1)". It should say **blank_sel == 1**.*

---

## Common mistakes

- Forgetting that with D flip-flops, **D = next state**. You don't need a separate excitation table.
- Getting the flip-flop count wrong: 5 states need **3** flip-flops, not 2.
- Calling a machine Moore when an output depends on an input (like read here). That makes it **Mealy**.
- Ignoring don't-cares. They often make the logic much simpler.

## Quick summary

- FSM = flip-flops (state) + next-state logic + output logic.
- Moore: outputs come from the state only. Mealy: they come from the state and the inputs.
- Design process: state diagram → transition table → encoding → D = next state → simplify → output logic.
- Controllers: the FSM reads information signals and drives control signals for a datapath.

---

## 📝 Quiz

**Q1.** What is the "state" of a sequential circuit?

<details><summary>Answer</summary>

The value currently stored in its **memory** (all of its flip-flops).
</details>

**Q2.** What is the difference between a Moore machine and a Mealy machine?

<details><summary>Answer</summary>

In a **Moore** machine, the outputs depend only on the current state. In a **Mealy** machine, they depend on the current state **and** the current inputs.
</details>

**Q3.** An FSM has 5 states. How many flip-flops does it need?

<details><summary>Answer</summary>

⌈log₂ 5⌉ = **3** (2 flip-flops only give 4 states).
</details>

**Q4.** In example 1, the state is 10. What does the circuit output, and what is the next state?

<details><summary>Answer</summary>

Output O₂O₁O₀ = **101** (5). Next state: D₁ = 1 ⊕ 0 = 1 and D₀ = NOT 0 = 1, so **11**.
</details>

**Q5.** Design the next-state logic for a 2-bit counter that goes 00 → 01 → 11 → 10 → 00, using D flip-flops.

<details><summary>Answer</summary>

| Q₁Q₀ | D₁D₀ |
|---|---|
| 00 | 01 |
| 01 | 11 |
| 11 | 10 |
| 10 | 00 |

D₁ is 1 in rows 01 and 11, so **D₁ = Q₀**. D₀ is 1 in rows 00 and 01, so **D₀ = Q̄₁**.
</details>

**Q6.** In the hex printer, why is it a Mealy machine?

<details><summary>Answer</summary>

The output **read** depends on the input **rdy** as well as the state (read = rdy · Q̄₁ · Q̄₀).
</details>

**Q7.** In the hex printer, the user presses "K" (ASCII 0x4B). Which three characters are printed, and in which states?

<details><summary>Answer</summary>

S1 prints **'4'** (high nibble), S2 prints **'B'** (low nibble), and S3 prints **' '** (space).
</details>

**Q8.** Why can sel_nibble be "x" (don't care) in state S3?

<details><summary>Answer</summary>

In S3, blank_sel = 1, so the MUX chooses the space character. The digit from the ROM isn't used, so it doesn't matter which nibble is selected.
</details>

**Q9.** In a controller design, what's the difference between an information signal and a control signal?

<details><summary>Answer</summary>

**Information** signals go from the datapath **to** the FSM (its inputs, like rdy). **Control** signals go **from** the FSM to the datapath (its outputs, like read and wr_en).
</details>
