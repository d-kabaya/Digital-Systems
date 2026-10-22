# Lesson 3.2 — Comparison, Binary Multiplication & Division

> Based on lecture slides **3.2 Performing binary multiplication and division** (COMP20020).
> ⬅️ [3.1 Signed Integers](08-signed-integers.md) · [Index](../README.md) · ➡️ [3.3 Fixed & Floating Point](10-fixed-and-floating-point.md)

## What are we learning?

1. How to **compare** two numbers in hardware.
2. **Multiplication** with shift-and-add, the array multiplier circuit, and signed multiplication.
3. **Division** with the long-division algorithm, and the combinational divider circuit.

Your Logisim file [`combinational_divider_and_multiplier.circ`](../circuits/combinational_divider_and_multiplier.circ) contains both circuits.

---

## 1. Comparing numbers

**General comparison (CPUs):** compute A − B and look at the result.

- A − B = 0 means **A = B**.
- A − B < 0 means **A < B**. (Watch out for overflow!)

**Equality only, which is simpler:** remember that **XNOR means "is equal"**.

- Compare each bit pair: Eqᵢ = A[i] XNOR B[i].
- **AND** all of those together. The output is 1 only if every bit matches.

```
A==B  =  (A3 XNOR B3)·(A2 XNOR B2)·(A1 XNOR B1)·(A0 XNOR B0)
```

## 2. Binary multiplication

It works exactly like long multiplication in decimal, but **easier**: each partial product is either **0** or **a copy of the multiplicand**.

```
        101     (5)   multiplicand
      × 110     (6)   multiplier
      -----
        000           ← multiplier bit 0 = 0, so this row is 0
       101_           ← bit 1 = 1, so copy, shifted 1 place
    + 101__           ← bit 2 = 1, so copy, shifted 2 places
    -------
      11110     (30) ✔
```

**Rule:** for each multiplier bit, if it's 1, write the multiplicand **shifted left by that bit's position**. Then add all the rows.

### The hardware: array multiplier

- Each partial-product bit is **A[i] AND B[j]**, because multiplying single bits is just AND.
- Rows of **half adders (HA)** and **full adders (FA)** add the shifted rows together.
- In your Logisim file, each partial product is one **4-bit-wide AND** gate (A ANDed with a copy of B[j]), followed by a chain of 4-bit adders.

### How many bits does the product need?

Two *n*-bit numbers multiplied together need **2n bits**.

- Example: 1111 × 1111 = 15 × 15 = 225 = **11100001**, which is 8 bits.
- (The maximum is (2ⁿ−1)² = 2²ⁿ − 2ⁿ⁺¹ + 1 < 2²ⁿ.)

This matches your [2-bit multiplier truth table](../worked-examples/2bit-multiplier-truth-table.jpeg): 2-bit × 2-bit gives a 4-bit output, and the largest result is 3 × 3 = 9 = 1001.

### Signed (two's complement) multiplication

**Sign-extend** the negative multiplicand to the full result width (2n bits), then multiply as normal and keep 2n bits.

Example from the slides: −3 × 6 in 8 bits.

```
   11111101   (−3, sign-extended to 8 bits)
 ×     0110   (6)
 ----------
   00000000
   1111101_
   111101__
 + 00000___
 ----------
   11101110   = −128+64+32+8+4+2 = −18 ✔
```

## 3. Binary division

It's long division again. In binary, at each step the divisor either "goes in" once (quotient bit 1) or not at all (quotient bit 0).

```
        011        (quotient 3)
     ------
  11 ) 1001        (9 ÷ 3)
        11
        --
         11
         11
         --
          0        (remainder 0)
```

### The algorithm (Harris & Harris §5.2.7)

```
R′ = 0
for i = N−1 down to 0:
    R = {R′ << 1, A[i]}     // shift R′ left and bring down the next bit of A
    D = R − B
    if D < 0:  Q[i] = 0,  R′ = R    // B doesn't fit
    else:      Q[i] = 1,  R′ = D    // B fits: subtract it
R = R′                              // final remainder
```

A = dividend, B = divisor, Q = quotient, R = remainder.

### Worked trace: 13 ÷ 3 (A = 1101, B = 0011)

| i | Bring down A[i] → R | D = R − 3 | Q[i] | New R′ |
|---|---|---|---|---|
| 3 | 0001 (1) | −2 (negative) | 0 | 0001 |
| 2 | 0011 (3) | 0 | **1** | 0000 |
| 1 | 0000 (0) | −3 | 0 | 0000 |
| 0 | 0001 (1) | −2 | 0 | 0001 |

✅ **Q = 0100 = 4, R = 1** (13 = 4 × 3 + 1)

### The hardware: combinational divider

Each row of the algorithm becomes **one stage**:

- a **subtractor** computes R − B,
- its **borrow-out** tells you whether D < 0,
- a **MUX** picks either R (if D < 0) or D (otherwise) as the next R′,
- the **inverted borrow** is the quotient bit.

In your Logisim divider there are 4 subtractor + MUX stages, one per quotient bit. There's also a **NOR gate on the divisor bits** that lights a "**division by zero**" LED when Y = 0000.

---

## Common mistakes

- Forgetting to **shift** each partial product.
- Giving the product too few bits. An n×n multiply needs **2n** bits.
- Not sign-extending a negative multiplicand.
- In division, forgetting to bring down the next dividend bit, or not keeping R when D < 0.

## Quick summary

- Equality: XNOR each bit pair, then AND them all. General comparison: subtract.
- Multiplication: AND gives the partial products, shift them, then add. n × n needs 2n bits.
- Signed multiplication: sign-extend first.
- Division: repeated "shift, subtract, check the sign". Each step gives one quotient bit.

---

## 📝 Quiz

**Q1.** Which gate checks whether two bits are equal?

<details><summary>Answer</summary>

**XNOR**, which outputs 1 when the inputs match.
</details>

**Q2.** Design a 2-bit equality comparator (A₁A₀ vs B₁B₀).

<details><summary>Answer</summary>

**EQ = (A₁ XNOR B₁) · (A₀ XNOR B₀)**
</details>

**Q3.** Multiply 1011 × 1101 in binary (11 × 13).

<details><summary>Answer</summary>

```
      1011
    × 1101
    ------
      1011        (bit 0 = 1)
     0000_        (bit 1 = 0)
    1011__        (bit 2 = 1)
 + 1011___        (bit 3 = 1)
 ---------
  10001111   = 143 ✔
```
</details>

**Q4.** How many output bits does a 4-bit × 4-bit unsigned multiplier need? What is its largest possible output?

<details><summary>Answer</summary>

**8 bits.** The largest output is 15 × 15 = **225** = 11100001.
</details>

**Q5.** Why does a single partial-product bit only need an AND gate?

<details><summary>Answer</summary>

Multiplying two single bits gives 1 only when **both** are 1, which is exactly AND.
</details>

**Q6.** What must you do to a negative multiplicand before two's complement multiplication?

<details><summary>Answer</summary>

**Sign-extend** it to the full result width by copying the sign bit (1) into all the new upper bits.
</details>

**Q7.** Use the division algorithm to divide 1110 (14) by 0100 (4). Give Q and R.

<details><summary>Answer</summary>

| i | R | D = R − 4 | Q[i] | R′ |
|---|---|---|---|---|
| 3 | 1 | −3 | 0 | 1 |
| 2 | 11 (3) | −1 | 0 | 3 |
| 1 | 111 (7) | 3 | 1 | 3 |
| 0 | 110 (6) | 2 | 1 | 2 |

**Q = 0011 = 3, R = 2** (14 = 3 × 4 + 2) ✔
</details>

**Q8.** In the combinational divider, what signal decides each quotient bit?

<details><summary>Answer</summary>

The **borrow (sign) from the subtractor** that computes R − B. No borrow means D ≥ 0, so the quotient bit is 1, and the MUX passes D through. A borrow means the quotient bit is 0, and the MUX passes R.
</details>

**Q9.** In your divider circuit, how is "division by zero" detected?

<details><summary>Answer</summary>

A **4-input NOR** on the divisor bits outputs 1 only when all of them are 0.
</details>
