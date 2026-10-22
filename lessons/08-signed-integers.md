# Lesson 3.1 — Binary Addition & Signed Integers (Two's Complement)

> Based on lecture slides **3.1 Representing signed integer numbers in binary** (COMP20020).
> ⬅️ [2.6 Building Blocks](07-building-blocks.md) · [Index](../README.md) · ➡️ [3.2 Multiplication & Division](09-multiplication-division.md)

## What are we learning?

1. How to add binary numbers, and the **full adder** circuit that does it.
2. How to store **negative** numbers: sign-and-magnitude, then **two's complement**, which is what real computers use.
3. **Overflow**: how to detect it, and how many bits you need to avoid it.
4. How one adder can do subtraction too.

---

## 1. Binary addition

The rules for adding single bits:

```
0+0 = 0     0+1 = 1     1+0 = 1     1+1 = 10  (write 0, carry 1)
1+1+1 = 11  (write 1, carry 1)
```

Example, 3 + 3:

```
  carry: 1 1
           1 1
       +   1 1
       -------
         1 1 0   = 6 ✔
```

### Full adder (single bit)

Inputs: X, Y and **Carry In (CI)**. Outputs: **Sum** and **Carry Out (CO)**.

| X | Y | CI | CO | Sum |
|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 | 1 |
| 0 | 1 | 0 | 0 | 1 |
| 1 | 0 | 0 | 0 | 1 |
| 0 | 1 | 1 | 1 | 0 |
| 1 | 0 | 1 | 1 | 0 |
| 1 | 1 | 0 | 1 | 0 |
| 1 | 1 | 1 | 1 | 1 |

> 📌 *Additional, but worth knowing: Sum = X ⊕ Y ⊕ CI and CO = XY + CI(X ⊕ Y). A **half adder** has no carry-in: Sum = X ⊕ Y and CO = XY.*

### Ripple-carry adder

Chain *n* full adders together, with each one's carry-out feeding the next one's carry-in. It's simple, but **slow for wide numbers**, because the carry may have to "ripple" through all *n* stages. That makes the critical path long. Faster designs exist, such as **carry look-ahead** and **prefix adders**, but they use more hardware.

## 2. Unsigned overflow and the number wheel

An *n*-bit circuit can only hold **2ⁿ** values. With 4 bits, that's 0000 to 1111 (0 to 15). If a result goes past the end, it **wraps around**, like a car's odometer:

- 15 + 2 = 10001, but only 4 bits are kept, so the answer is **0001** with **carry = 1**.
- 2 − 5 → **1101** with **borrow = 1**.

For **unsigned** numbers: **overflow ⇔ carry (or borrow) = 1**.

## 3. Signed numbers, attempt 1: sign and magnitude

Use the leftmost bit as the sign (0 = +, 1 = −) and the rest for the size:

```
 5 = 0000 0101       -5 = 1000 0101
```

**Problems:**

- There are **two zeros**: 0000 0000 and 1000 0000.
- It needs extra circuits to compare signs and magnitudes, plus separate adder and subtractor hardware.

So it's not used for integers.

## 4. Signed numbers, attempt 2: **two's complement** ✅

**Key insight:** on the wheel, adding 2ⁿ − 1 is the same as subtracting 1. More generally, adding (2ⁿ − Y) is the same as subtracting Y. So a negative number can be stored as the bit pattern that *acts like* it when you add.

With 4 bits:

```
Bits:   0000 0001 ... 0111 | 1000 1001 ... 1110 1111
Value:    0    1  ...   7  |  -8   -7  ...   -2   -1
```

- **MSB = 0 means positive** and **MSB = 1 means negative**.
- The range for *n* bits is **−2ⁿ⁻¹ … +2ⁿ⁻¹ − 1**. For 4 bits that's −8 … +7, and for 8 bits it's −128 … +127.
- There's only **one zero**.
- An **ordinary adder works unchanged**.

### How to negate (compute −X)

1. **Invert every bit.**
2. **Add 1.**

Example: −2 in 4 bits. 2 = 0010, inverted = 1101, plus 1 = **1110**.

To read a negative number, apply the same two steps. For example, 1110 → 0001 + 1 = 0010 = 2, so 1110 = −2.

## 5. Worked examples (from the slides)

**Example 1:** 6 + (−2), 4 bits

```
  0110   ( 6)
+ 1110   (-2)
------
 10100   → keep 4 bits → 0100 = 4 ✔   (the carry out is just discarded)
```

**Example 2:** −5 + (−3), 8 bits

```
 −5 = ~00000101 + 1 = 11111011
 −3 = ~00000011 + 1 = 11111101
 sum = 1 11111000 → 11111000 → MSB is 1, so it's negative:
                   ~11111000 + 1 = 00001000 = 8 → −8 ✔
```

**Example 3: overflow!** −6 + (−3), 4 bits

```
 −6 = 1010, −3 = 1101
 1010 + 1101 = 1 0111 → 0111 = +7 ✗  (should be −9, which doesn't fit in 4 bits)
```

## 6. Detecting signed overflow

There are two equivalent rules:

1. **Sign rule:** both inputs have the **same sign**, but the result has the **opposite sign**.
2. **Carry rule:** the carry **into** the MSB column ≠ the carry **out of** it.

> ⚠️ For signed numbers, the carry out on its own does **NOT** mean overflow. In Example 1 the carry out was 1, but the answer is correct.

**How many bits avoid overflow?** Adding two *n*-bit numbers needs at most **n + 1** bits. In 4 bits, the extremes are 7 + 7 = 14 and (−8) + (−8) = −16, and both fit in 5 bits.

Real-world example: in Java, `int` is 32-bit signed, so `2000000000 + 2000000000` overflows and prints a **negative** number.

## 7. Subtraction with the same adder

```
A − B = A + (−B) = A + ~B + 1
```

- Invert B, and feed **1** into the adder's carry-in.
- **Adder/subtractor trick:** put an **XOR** on each B bit, with the other XOR input wired to a *control* line. Also connect *control* to the carry-in.
  - control = 0: XOR passes B through and Cin = 0, so the result is **A + B**.
  - control = 1: XOR inverts B and Cin = 1, so the result is **A + ~B + 1 = A − B**.

This works because X ⊕ 0 = X and X ⊕ 1 = X̅.

---

## Common mistakes

- Forgetting the **+1** after inverting.
- Treating the carry out as signed overflow. Use the **sign rule** instead.
- Using the wrong range. With *n* bits, the most negative value has one *more* step than the most positive: −8 … +7.
- Not padding to the full width before inverting. −2 in 8 bits is 1111 1110, not 1110.

## Quick summary

- Full adder: 3 inputs (X, Y, CI) → Sum and CO. Chain them to make a ripple-carry adder.
- Two's complement: negate by inverting the bits and adding 1. The MSB is the sign. The range is −2ⁿ⁻¹ … 2ⁿ⁻¹−1.
- Signed overflow: same-sign inputs give an opposite-sign result (or carry in ≠ carry out at the MSB).
- Subtraction is A + ~B + 1, so one adder plus XORs gives you both.

---

## 📝 Quiz

**Q1.** Add 0101 + 0011 in binary. What is the result in decimal?

<details><summary>Answer</summary>

0101 + 0011 = **1000** = 8.
</details>

**Q2.** Write −5 as a 4-bit two's complement number.

<details><summary>Answer</summary>

5 = 0101, inverted = 1010, plus 1 = **1011**.
</details>

**Q3.** What is the decimal value of the 8-bit two's complement number 1001 1100?

<details><summary>Answer</summary>

The MSB is 1, so it's negative. Invert and add 1: 0110 0011 + 1 = 0110 0100 = 100. So the value is **−100**.
</details>

**Q4.** What is the range of an 8-bit two's complement number? And of a 16-bit one (MySQL SMALLINT)?

<details><summary>Answer</summary>

- 8-bit: **−128 … +127**
- 16-bit: **−32768 … +32767**
</details>

**Q5.** Compute 5 + 4 in 4-bit two's complement. Is there overflow?

<details><summary>Answer</summary>

0101 + 0100 = **1001**, which reads as −7. Both inputs are positive but the result is negative, so **yes, overflow**. (9 doesn't fit in the range −8…7.)
</details>

**Q6.** Compute 3 + (−5) in 4-bit two's complement.

<details><summary>Answer</summary>

−5 = 1011. 0011 + 1011 = **1110** = −2 ✔. The inputs have different signs, so overflow is impossible.
</details>

**Q7.** In sign and magnitude, what are the two representations of zero in 8 bits?

<details><summary>Answer</summary>

**0000 0000** (+0) and **1000 0000** (−0).
</details>

**Q8.** In the adder/subtractor circuit, what are the XOR outputs and the carry-in when control = 1?

<details><summary>Answer</summary>

The XORs output **NOT B** (every bit of B inverted), and the carry-in is **1**. So the circuit computes A + ~B + 1 = A − B.
</details>

**Q9.** Why is a ripple-carry adder slow for 64-bit numbers?

<details><summary>Answer</summary>

Each full adder has to wait for the carry from the one before it. In the worst case, the carry ripples through all **64** stages, which makes the critical path very long.
</details>

**Q10.** For **unsigned** 4-bit numbers, how do you know that 15 + 2 overflowed?

<details><summary>Answer</summary>

The **carry out = 1**. The kept result, 0001, is wrong.
</details>
