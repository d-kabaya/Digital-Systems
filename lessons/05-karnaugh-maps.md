# Lesson 2.3 — Karnaugh Maps (K-maps)

> Based on lecture slides **2.3 Karnaugh maps** (COMP20020).
> ⬅️ [2.1 Combinational Circuits](04-combinational-circuits.md) · [Index](../README.md) · ➡️ [2.4 Simplification & Universal Gates](06-simplification-universal-gates.md)

## What are we learning?

Sum of Products (SOP) straight from a truth table works, but it's **big**: one AND gate for every 1 in the table. A **Karnaugh map** is a visual way to find the **minimum SOP**, which means fewer gates.

> 📌 *Background (additional): a **standard SOP** term (a minterm) contains **every** variable, e.g. A̅B̅C̅D̅. A K-map merges neighbouring minterms. It's based on the rule X·Y + X̅·Y = Y: when one variable appears both barred and unbarred, it cancels out.*

---

## 1. Why it works, in one line

Two cells that differ in **exactly one bit** can be merged, and that bit disappears:

```
A·B·C·D̅ + A̅·B·C·D̅ = (A + A̅)·B·C·D̅ = B·C·D̅
```

## 2. Drawing the map

A 4-variable K-map has rows for **AB** and columns for **CD**, both ordered **00, 01, 11, 10**:

```
         CD
         00   01   11   10
AB 00 |  0    1    3    2
   01 |  4    5    7    6
   11 | 12   13   15   14
   10 |  8    9   11   10
```

(The numbers are the truth-table row numbers. **Watch the order: 0 1 3 2.**)

> ⚠️ **The two most important rules:**
> 1. The order is **00, 01, 11, 10** (Gray code), not 00, 01, 10, 11. Neighbouring cells must differ by only **one bit**.
> 2. The map **wraps around**. The left edge touches the right edge, and the top edge touches the bottom.

A 3-variable map uses A for the rows and BC for the columns (00 01 11 10), which gives 2 × 4 cells.

## 3. The method (5 steps)

1. Draw an empty K-map.
2. Fill in the 1s from the truth table. You can leave the 0s blank.
3. **Group the 1s:**
   - Group sizes must be a **power of 2** (1, 2, 4, 8 or 16).
   - Groups are rectangles of **adjacent** cells, horizontally or vertically. **Wrap-around counts.**
   - Make each group as **large as possible**. Groups may overlap.
   - Every 1 must be in at least one group.
   - Remove any group that lies entirely inside other groups.
4. Turn each group into a product term. **Keep the variables that do NOT change** inside the group, and drop the ones that do.
5. OR the terms together.

## 4. Worked example (from the slides)

Truth table: Y = 1 at rows 0, 1, 6, 8, 9, 10, 11, 14.

```
         CD
         00   01   11   10
AB 00 |  1    1    .    .
   01 |  .    .    .    1
   11 |  .    .    .    1
   10 |  1    1    1    1
```

**Group 1:** the bottom row (AB = 10), 4 cells. A=1 and B=0 stay fixed while C and D change, so the term is **AB̅**.

**Group 2:** the 2×2 block made of columns CD = 00, 01 and rows AB = 00 and 10. Rows 00 and 10 are adjacent because the map wraps from top to bottom. Here B=0 and C=0 stay fixed, so the term is **B̅C̅**.

**Group 3:** column CD = 10, rows AB = 01 and 11. B=1, C=1 and D=0 stay fixed while A changes, so the term is **BCD̅**.

✅ **Y = B̅C̅ + AB̅ + BCD̅**

That's 3 small terms instead of 8 four-variable minterms.

## 5. Measuring the saving in gate equivalents (G.E.)

The slides measure circuit **area** in gate equivalents: NOT = 0.7, AND = 1.3, OR = 1.3 (per 2-input gate).

Pop-quiz result from the slides: a 10-minterm SOP minimised to **D̅ + B̅C̅**.

- Before: 4 NOT + 30 AND + 9 OR = 2.8 + 39 + 11.7 = **53.5 G.E.**
- After: 2 NOT + 1 AND + 1 OR = 1.4 + 1.3 + 1.3 = **4 G.E.**

## 6. Don't-care values (x)

Sometimes certain input combinations **can never happen**. For example, a decimal keypad only produces 0000–1001, so 1010–1111 never occur. You can mark those outputs as **x (don't care)** and treat each x as a 1 *if that helps make a bigger group*. You never have to include an x.

**Example from the slides:** output = 1 for inputs 7, 8 and 9; inputs 10–15 are x.

```
         CD
         00   01   11   10
AB 00 |  .    .    .    .
   01 |  .    .    1    .
   11 |  x    x    x    x
   10 |  1    1    x    x
```

- Without using the don't-cares: AB̅C̅ + A̅BCD
- **Using them:** the bottom two rows (AB = 11 and 10) form an 8-cell group, giving **A**. The 1 at 0111 pairs with the x at 1111, giving **BCD**.

✅ **Output = A + BCD**

## 7. Limits of K-maps

- They find the **minimal SOP**, which isn't always the minimal **circuit**.
- Sometimes you can factor the result further (e.g. AB + AC = A(B + C)), or rewrite it to use XOR/NAND/NOR.
- They get impractical for more than about 4–5 variables.

---

## Common mistakes

- Ordering the columns 00 01 **10 11**. It must be 00 01 **11 10**.
- Forgetting the **wrap-around**: corners and opposite edges are neighbours.
- Making a group of 3 or 6. Group sizes must be powers of 2.
- Grouping diagonally. Only horizontal and vertical adjacency counts.
- Keeping a variable that **changes** inside the group. Changing variables must be dropped.
- Making groups smaller than they could be. Bigger groups give simpler terms.

## Quick summary

- A K-map is a truth table laid out so that neighbouring cells differ by one bit.
- Make the largest power-of-2 rectangles you can (with wrap-around) that cover every 1.
- Each group becomes a term made of the variables that stay constant.
- Don't-cares are free 1s if they help.

---

## 📝 Quiz

**Q1.** What is the column order on a 4-variable K-map, and why?

<details><summary>Answer</summary>

**00, 01, 11, 10.** This is Gray code, so that neighbouring cells differ by only one bit. That's what lets them merge.
</details>

**Q2.** Which group sizes are allowed?

<details><summary>Answer</summary>

Powers of 2: **1, 2, 4, 8, 16**.
</details>

**Q3.** A group of 4 cells covers AB = 00 and 01 with CD = 00 and 01. What term does it give?

<details><summary>Answer</summary>

A = 0 is constant, B changes, C = 0 is constant, and D changes. The term is **A̅C̅**.
</details>

**Q4.** Are the cells at AB=00, CD=00 and AB=00, CD=10 adjacent?

<details><summary>Answer</summary>

**Yes.** The map wraps from left to right, and 00 and 10 differ in one bit (C).
</details>

**Q5.** Minimise the 3-variable function F(A,B,C) = 1 for minterms 0, 2, 4, 6. Everything else is 0.

<details><summary>Answer</summary>

Those are all the rows where **C = 0**: 000, 010, 100, 110. On the 3-variable map they fill the BC = 00 and BC = 10 columns, which are adjacent through wrap-around. That's one group of 4, so **F = C̅**.
</details>

**Q6.** Minimise F(A,B,C) = 1 for minterms 3, 5, 6, 7 (this is the "majority" function).

<details><summary>Answer</summary>

Three groups of 2 overlap at 111:

- 011 + 111 → **BC**
- 101 + 111 → **AC**
- 110 + 111 → **AB**

**F = AB + BC + AC**
</details>

**Q7.** What is a "don't care", and how do you use it?

<details><summary>Answer</summary>

It's an output for an input combination that **can never occur**. You may treat it as 1 if that makes a bigger group, or ignore it. You never *have* to cover it.
</details>

**Q8.** Fill a 4-variable map with 1s in **all four corners** only (minterms 0, 2, 8, 10). What is the minimal expression?

<details><summary>Answer</summary>

The four corners are mutually adjacent through wrap-around in both directions, so they form one group of 4. B = 0 and D = 0 stay constant, so **F = B̅D̅**.
</details>

**Q9.** Using the gate equivalents NOT = 0.7, AND = 1.3 and OR = 1.3, what is the area of B̅C̅ + AB̅ + BCD̅? Assume NOTs for B, C and D, and count a 3-input AND as two 2-input ANDs.

<details><summary>Answer</summary>

- NOTs: B̅, C̅, D̅ = 3 × 0.7 = 2.1
- ANDs: B̅C̅ (1) + AB̅ (1) + BCD̅ (2) = 4 × 1.3 = 5.2
- ORs: 3 terms need 2 ORs = 2 × 1.3 = 2.6
- **Total = 9.9 G.E.**

The exact number depends on how you count, but the method is what matters.
</details>
