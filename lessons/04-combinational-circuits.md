# Lesson 2.1 — Describing Combinational Circuits (Truth Tables & Boolean Algebra)

> Based on lecture slides **2.1 Describing combinational circuits** (COMP20020).
> ⬅️ [1.3 Logic Gates](03-logic-gates.md) · [Index](../README.md) · ➡️ [2.3 Karnaugh Maps](05-karnaugh-maps.md)

## What are we learning?

There are three ways to describe the same circuit: a **truth table**, a **Boolean expression**, and a **circuit diagram**. This lesson shows how to move between them.

---

## 1. Combinational vs sequential

| | Combinational | Sequential |
|---|---|---|
| Output depends on | **current** inputs only | current **and previous** inputs |
| Memory? | ❌ none | ✅ has memory (state) |
| Example | adder, multiplexer, lock logic | counter, register |

A combinational circuit still has a small delay while its transistors switch, but it never "remembers" anything.

## 2. Truth tables

> "A truth table defines a logic operation by listing **all combinations** of input values and the resulting output."

- With *n* inputs there are **2ⁿ rows**: 3 inputs give 8 rows, and 4 inputs give 16.
- Write the rows in binary counting order (000, 001, 010, …) so you don't miss any.
- A truth table is a **specification**. Many different circuits can implement the same table.

### Example: combination lock with multiple codes

Two key combinations should open the lock:

- **A and C pressed** (for ordinary users)
- **only B pressed** (the master key)

| A | B | C | Release |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 |
| 0 | 1 | 0 | **1** ← only B |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | **1** ← A and C |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 0 |

**Release = A·B̅·C + A̅·B·C̅**

Your Logisim file [`circuits/combination_lock_multiple_codes.circ`](../circuits/combination_lock_multiple_codes.circ) builds exactly this: two 3-input ANDs (with NOTs on the right inputs) feeding one OR.

## 3. XOR and XNOR

| A B | XOR (A⊕B) | XNOR |
|---|---|---|
| 0 0 | 0 | 1 |
| 0 1 | 1 | 0 |
| 1 0 | 1 | 0 |
| 1 1 | 0 | 1 |

- **XOR** means "the inputs are **different**".
- **XNOR** means "the inputs are **equal**". You'll use this for comparators in Lesson 3.2.

**How many different 2-input gates are possible?** The output column has 4 rows, each 0 or 1, so there are 2⁴ = **16** possible functions. They include AND, OR, XOR, NAND, NOR and XNOR, as well as trivial ones like "always 0" and "just copy A".

## 4. Boolean algebra

George Boole (the first maths professor at Queen's College Cork) invented an algebra of true/false values in 1854. In 1938, Claude Shannon showed it could be used to **design circuits**.

**The big idea:** a Boolean operator is a gate, and a Boolean expression is a circuit. They correspond directly.

| Notation | Meaning |
|---|---|
| A̅ | NOT A |
| AB or A·B | A AND B |
| A + B | A OR B |
| A ⊕ B | A XOR B |

### Order of precedence (highest first)

1. Brackets
2. NOT
3. AND
4. OR

So **A + BC** means **A + (B·C)**, not (A + B)·C. It works just like × before + in ordinary maths.

## 5. Converting between the three forms

### Circuit → expression

1. Start at the inputs.
2. Trace forward through each gate, writing the expression on each wire as you go.
3. The expression on the final wire is your answer.

### Expression → circuit

1. Identify the inputs and outputs.
2. Draw gates for the **highest-precedence** operations first: NOTs, then ANDs, then the final OR.

Example: Z = A + B̅C. Draw a NOT on B, then an AND(B̅, C), then an OR(A, that AND).

### Expression → truth table

1. List all input combinations.
2. Work out the output for each row. Helper columns for sub-expressions make this easier.

Example: **Z = A + BC**

| A | B | C | BC | Z |
|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 | 0 |
| 0 | 1 | 0 | 0 | 0 |
| 0 | 1 | 1 | 1 | **1** |
| 1 | 0 | 0 | 0 | **1** |
| 1 | 0 | 1 | 0 | **1** |
| 1 | 1 | 0 | 0 | **1** |
| 1 | 1 | 1 | 1 | **1** |

### Truth table → expression (Sum of Products)

> 📌 *Additional explanation. The slides call this "straightforward synthesis using Sum of Products". The detailed lecture on it (2.2) isn't in the uploaded set.*

1. Find every row where the output is **1**.
2. For each of those rows, write an AND term (a **minterm**) using each variable as-is if it's 1, or with a bar if it's 0.
3. OR all the terms together.

For the lock, row 010 gives A̅BC̅ and row 101 gives AB̅C, so **Release = A̅BC̅ + AB̅C**. ✔

## 6. The logic design process (from the slides)

1. Read the plain-English specification.
2. Identify the inputs and outputs.
3. State what each input and output means.
4. Specify the behaviour formally with a truth table or Boolean expression.
5. Synthesise the circuit, using one of these:
   - inspection (just think about it),
   - Sum of Products (straightforward),
   - **Karnaugh maps** (better). That's the next lesson.

---

## Worked examples in this repo

Your handwritten [**2-bit multiplier truth table**](../worked-examples/2bit-multiplier-truth-table.jpeg) is a good example of a multi-output truth table. It has 4 inputs (x₁x₀, y₁y₀), so 16 rows, and 4 outputs (z₃…z₀). All 16 rows are correct, from 00×00 = 0000 up to 11×11 = 1001 (9).

Your [**1-bit multiplexer truth table**](../worked-examples/1bit-multiplexer-truth-table.jpeg) is also correct: Z = A when SEL = 0 and Z = B when SEL = 1. As SOP, that's **Z = SEL̅·A + SEL·B**.

---

## Common mistakes

- Reading A + BC as (A + B)C. **AND binds tighter than OR.**
- Missing rows in a truth table. Count in binary and check you have 2ⁿ rows.
- In SOP, putting a bar on variables that are 1. The rule is the other way round: **0 gets a bar**.

## Quick summary

- Combinational means no memory. Sequential means it has memory.
- A truth table has 2ⁿ rows and is the full specification of a circuit.
- Boolean expressions ↔ circuits. Precedence is () > NOT > AND > OR.
- SOP: one AND term for every row that outputs 1, then OR them together.

---

## 📝 Quiz

**Q1.** A circuit has 4 inputs. How many rows does its truth table need?

<details><summary>Answer</summary>

2⁴ = **16**
</details>

**Q2.** Is a circuit whose output depends on *previous* inputs combinational or sequential?

<details><summary>Answer</summary>

**Sequential.** It must have memory to know about previous inputs.
</details>

**Q3.** Write the truth table for Z = A̅B.

<details><summary>Answer</summary>

| A | B | Z |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | **1** |
| 1 | 0 | 0 |
| 1 | 1 | 0 |
</details>

**Q4.** In Z = A + B̅C, which operation is done first, and which last?

<details><summary>Answer</summary>

First the **NOT** on B, then **AND** (B̅·C), and last the **OR** with A.
</details>

**Q5.** Write the truth table for Z = A̅ + B.

<details><summary>Answer</summary>

| A | B | Z |
|---|---|---|
| 0 | 0 | 1 |
| 0 | 1 | 1 |
| 1 | 0 | **0** |
| 1 | 1 | 1 |

The output is 0 only when A=1 and B=0.
</details>

**Q6.** Write the SOP expression for this table:

| A | B | Y |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

<details><summary>Answer</summary>

Rows 01 and 10 output 1, so **Y = A̅B + AB̅**. That's **XOR** (A ⊕ B).
</details>

**Q7.** Trace this circuit: A goes into a NOT; the NOT's output and B go into an AND; that AND's output and C go into an OR. What is the output?

<details><summary>Answer</summary>

**A̅B + C**
</details>

**Q8.** Why are there exactly 16 possible 2-input logic functions?

<details><summary>Answer</summary>

A 2-input truth table has 4 rows, and each row's output can be 0 or 1. That gives 2⁴ = **16** different output columns.
</details>

**Q9.** A lock opens when exactly one of two buttons, X or Y, is pressed. Which gate is that?

<details><summary>Answer</summary>

**XOR**, which outputs 1 when the inputs differ.
</details>
