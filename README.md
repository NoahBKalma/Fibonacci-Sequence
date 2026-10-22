# fib_nums

Prints the first Fibonacci numbers (F0 through Fn) in AArch64 Linux assembly, separated by commas.
n is defined on the line under CALC_LOOP:

Example for F8
```
0, 1, 1, 2, 3, 5, 8, 13, 21, 
```

## Build and run

Requires an AArch64 Linux machine (or VM) with the GNU toolchain.

```
as -o fib_nums.o fib_nums.s
ld -o fib_nums fib_nums.o
./fib_nums
```

## How it works

1. **Compute:** `x19` and `x20` hold the previous two Fibonacci numbers. Each loop iteration adds them to get the next one, which goes in `x3`.
2. **Split into digits:** `CALC_DIGITS` repeatedly divides by 10 (`udiv`, `msub`) to get the last digit, converts it to ASCII (+48), and pushes it on the stack. The last digit goes in first, so the first digit ends up on top.
3. **Print:** `PRINT_NUM` pops digits one at a time and writes each with the `write` syscall until `sp` is back where it started (saved in `x10`).
4. **Separator:** `WRITE_BREAK` prints `", "` after each number.

## Notes

- Each digit uses a 16-byte stack slot, the minimum that keeps `sp` 16-byte aligned.
- Registers are 64-bit, so the largest Fibonacci number that works is F93 (12,200,160,415,121,876,738). F94 overflows.
- Output ends with a trailing `", "` before the final newline.
- Syscalls used: `write` (0x40) and `exit` (0x5D).

## Important Registers

| Register | Purpose |
|----------|---------|
| x3 | current Fibonacci number / working value |
| x19, x20 | previous two Fibonacci numbers |
| x21 | constant 10 |
| x4 | loop counter |
