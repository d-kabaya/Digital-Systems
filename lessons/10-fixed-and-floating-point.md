# Lesson 3.3 — Real Numbers: Conversions, Fixed-Point & Floating-Point (IEEE 754)

> Based on lecture slides **3.3 Fixed-point numbers and floating-point numbers** (COMP20020).
> ⬅️ [3.2 Multiplication & Division](09-multiplication-division.md) · [Index](../README.md)

## What are we learning?

1. Writing fractions in binary (radix point notation).
2. Converting decimal ↔ binary, **including the fractional part**.
3. **Fixed-point** numbers (Ua.b / Qa.b).
4. **Floating-point** numbers (IEEE 754 single precision).

---

## 1. Radix point notation

The **radix** (or base) is the number of digits a system uses. The **radix point** separates the whole-number part from the fraction. Digits to the right of the point have **negative positions**:

```
Decimal: -15.625₁₀  = −(1·10¹ + 5·10⁰ + 6·10⁻¹ + 2·10⁻² + 5·10⁻³)
Binary:  -1111.101₂ = −(8 + 4 + 2 + 1 + 0.5 + 0 + 0.125) = −15.625
```

The binary fraction place values are worth memorising: **½ = 0.5, ¼ = 0.25, ⅛ = 0.125, 1/16 = 0.0625**

## 2. Binary → decimal (sum of weights)

Multiply each bit by its column weight and add them up:

```
1011.1₂ = 8 + 0 + 2 + 1 + 0.5 = 11.5
```

## 3. Decimal → binary

### Integer part: divide by 2 repeatedly

Read the remainders from **bottom to top**.

| Calculation | Quotient | Remainder |
|---|---|---|
| 19 / 2 | 9 | 1 |
| 9 / 2 | 4 | 1 |
| 4 / 2 | 2 | 0 |
| 2 / 2 | 1 | 0 |
| 1 / 2 | 0 | 1 ↑ |

**19₁₀ = 10011₂**

### Fractional part: multiply by 2 repeatedly

Each time, take the integer part as the next bit, and keep only the fraction for the next step. Read the bits from **top to bottom**.

| Calculation | Integer part | Fraction |
|---|---|---|
| 0.3125 × 2 | 0 ↓ | .625 |
| 0.625 × 2 | 1 | .25 |
| 0.25 × 2 | 0 | .5 |
| 0.5 × 2 | 1 | .0 → stop |

**0.3125₁₀ = 0.0101₂**

> 💡 **Why it works:** dividing by the base removes the **rightmost** digit as the remainder, so the integer digits come out last-first. Multiplying by the base moves the **leftmost** fractional digit across the point, so the fractional digits come out first-first. It's the same method you used in base 10 in [`worked-examples/decimal-conversion.txt`](../worked-examples/decimal-conversion.txt).

### Fractions that repeat forever

Some decimal fractions never reach .0 in binary, just as 1/3 = 0.333… never ends in decimal:

```
0.3: .3→0 .6→1 .2→0 .4→0 .8→1 .6→1 .2→0 ... the steps from .6 onward repeat
5.3₁₀ = 101.0(1001)₂ = 101.0100110011...₂
```

That's why computers can't store 0.1 or 0.3 exactly.

> ⚠️ *Note on the slides: the slide writes the period as 0.(01001). The repeating part is really **1001**, starting after the first 0, i.e. 0.0(1001). The bits listed on the slide are right; only the bracket placement is off.*

## 4. Bit notation

If X = 010.1:

- X[0] = 0 (the bit just left of the point)
- X[1] = 1
- X[−1] = 1 (the first bit after the point)
- X[1:0] = 10
- **LSB** = the rightmost bit. **MSB** = the leftmost bit.
- Curly brackets mean **concatenation**: {X, 1} = 010.11

## 5. Fixed-point numbers

**Idea:** a fraction is just an integer with an **implied binary point**:

```
11100.111₂ = 11100111₂ × 2⁻³
```

So you can use ordinary **integer hardware** for fractional maths.

**Notation (Harris & Harris):**

- **Ua.b**: unsigned, with *a* integer bits and *b* fractional bits. U4.4 is 8 bits in total.
- **Qa.b**: signed (two's complement). Q13.3 is 16 bits in total.
- Ordinary integers are U16.0, Q8.0 and so on.

### Adding and subtracting: just use integers

When both numbers have the same scale (2⁻² here), you add the integers and keep the scale:

```
A = 6.5  = 110.10₂ = 11010 × 2⁻²
B = 5.25 = 101.01₂ = 10101 × 2⁻²

A + B = (11010 + 10101) × 2⁻² = 101111 × 2⁻² = 1011.11₂ = 11.75 ✔
A − B = (11010 − 10101) × 2⁻² =    101 × 2⁻² =    1.01₂ = 1.25 ✔
```

### Multiplying: the fraction bits double

```
A × B = (11010 × 10101) × 2⁻⁴ = 1000100010 × 2⁻⁴ = 100010.0010₂ = 34.125
```

If you only keep 2 fractional bits, the result becomes 100010.00₂ = **34.0**. The extra fraction bits have to be thrown away, so **you lose precision**.

> ⚠️ *Note on the slides: the slide says 30.125 / 30.0. The correct value is 6.5 × 5.25 = **34.125**, and 100010₂ = 34. The method on the slide is right; it's just an arithmetic typo.*

## 6. Floating-point numbers

Fixed point needs a huge number of bits to cover both very big and very small numbers. Floating point uses **scientific notation**:

```
value = mantissa × base^exponent
3 × 10⁷  = 30 000 000        3 × 10⁻⁷ = 0.0000003
```

**Normalised** means there is exactly one non-zero digit before the point. For example, 0.3 × 10³ is normalised to **3 × 10²**. In binary, the only non-zero digit is 1, so a normalised mantissa is always **1.xxxxx**.

### IEEE 754 single precision (32 bits)

```
| S (1 bit) | E (8 bits)        | M (23 bits)                 |
|  sign     | exponent + 127    | fraction after the "1."     |

value = (−1)^S × 1.M × 2^(E − 127)
```

- **S:** 0 means +, 1 means −.
- **E:** the true exponent **+ 127** (this offset is called the *bias*).
- **M:** the bits *after* the leading "1.". That 1 is **not stored** (it's implied), which gives one free bit of precision.
- Double precision is 64 bits and extended precision is 80 bits. The current standard is IEEE 754-2019.

### Floating point → decimal (example from the slides)

`0 10000011 01100000000000000000000`

1. S = 0, so the number is positive.
2. E = 10000011 = 131. The true exponent is 131 − 127 = **4**.
3. Mantissa = 1.011₂
4. 1.011 × 2⁴ = 10110₂ = **22**

### Decimal → floating point (example from the slides): 99

1. 99 = 1100011₂
2. Normalise: 1.100011 × 2⁶
3. S = 0. E = 6 + 127 = 133 = **10000101**. M = **100011**000…0
4. `0 10000101 10001100000000000000000` = **42C60000₁₆**

### Special values

| Value | S | E | M |
|---|---|---|---|
| +0 | 0 | 00000000 | all 0 |
| −0 | 1 | 00000000 | all 0 |
| +∞ | 0 | 11111111 | all 0 |
| −∞ | 1 | 11111111 | all 0 |
| NaN (not a number) | x | 11111111 | **non-zero** |
| Denormalised | x | 00000000 | non-zero → (−1)ˢ × **0**.M × 2⁻¹²⁶ |

---

## Common mistakes

- Reading the fraction bits bottom-up. **Integer remainders are read bottom-up, fraction integer-parts top-down.**
- Forgetting the **bias** of 127: you **add** it when encoding and **subtract** it when decoding.
- Storing the leading "1." in M. It's implied, so **don't** store it.
- Forgetting that fixed-point multiplication **doubles the number of fractional bits**.

## Quick summary

- Bits after the point are worth ½, ¼, ⅛, …
- Decimal → binary: divide by 2 for the integer part, multiply by 2 for the fraction.
- Fixed point is an integer with an implied point. Add and subtract easily, but multiplication loses precision.
- IEEE single precision is 1 sign bit + 8 exponent bits (bias 127) + 23 mantissa bits, with an implied leading 1.

---

## 📝 Quiz

**Q1.** Convert 13₁₀ to binary.

<details><summary>Answer</summary>

13/2 = 6 r **1**, 6/2 = 3 r **0**, 3/2 = 1 r **1**, 1/2 = 0 r **1**. Reading bottom-up gives **1101₂**.
</details>

**Q2.** Convert 2.125₁₀ to binary.

<details><summary>Answer</summary>

The integer part is 2 = 10. For the fraction: .125×2 = **0**.25, .25×2 = **0**.5, .5×2 = **1**.0, which gives .001. So the answer is **10.001₂**.
</details>

**Q3.** Convert 1101.11₂ to decimal.

<details><summary>Answer</summary>

8 + 4 + 0 + 1 + 0.5 + 0.25 = **13.75**
</details>

**Q4.** Convert 10010₂ to decimal.

<details><summary>Answer</summary>

16 + 2 = **18**
</details>

**Q5.** B = 5.3₁₀. What are B[1] and B[−2]?

<details><summary>Answer</summary>

5.3 = 101.0100110011…₂, so **B[1] = 0** and **B[−2] = 1**.
</details>

**Q6.** How many bits does a Q8.8 number use? Is it signed?

<details><summary>Answer</summary>

8 + 8 = **16 bits**, and **yes**, it's signed (Q means two's complement).
</details>

**Q7.** Using U3.2, add 3.25 + 1.5 as integers.

<details><summary>Answer</summary>

3.25 = 011.01 = 01101 × 2⁻² and 1.5 = 001.10 = 00110 × 2⁻². 01101 + 00110 = 10011, so the result is 100.11₂ = **4.75** ✔
</details>

**Q8.** Decode the IEEE single-precision hex value **42000000₁₆**.

<details><summary>Answer</summary>

In binary: 0100 0010 0000 0000 …

- S = 0
- E = 10000100 = 132, so the true exponent is 132 − 127 = 5
- M = 0, so the mantissa is 1.0

1.0 × 2⁵ = **32.0**
</details>

**Q9.** Encode **+102.25** in IEEE single precision. Give the answer in hex.

<details><summary>Answer</summary>

1. 102 = 1100110 and .25 = .01, so 102.25 = 1100110.01₂
2. Normalise: 1.10011001 × 2⁶
3. S = 0. E = 6 + 127 = 133 = 10000101. M = 10011001 000…
4. `0 10000101 10011001000000000000000`
5. Group into 4s: 0100 0010 1100 1100 1000 0000 0000 0000 = **42CC8000₁₆**
</details>

**Q10.** Which bit pattern means NaN, and how is it different from infinity?

<details><summary>Answer</summary>

Both have **E = all 1s**. **Infinity** has M = all 0s, and **NaN** has a **non-zero** M.
</details>

**Q11.** Why can't a computer store 0.1 exactly in binary floating point?

<details><summary>Answer</summary>

0.1 is a **repeating** binary fraction (0.0(0011)₂). The repeated multiply-by-2 never reaches .0, so it has to be cut off after a fixed number of bits.
</details>
