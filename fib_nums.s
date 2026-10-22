
	.global _start
	.text

_start:
	mov x21, #10		// 10 stored for modulo 10

	mov x19, #0		// n-1
	mov x20, #1		// n
	mov x3, x20		// n	
	mov x4, #1		// loop var

	mov x8, #0x40		// PRINT 0, 1 for first two fib numbers
	mov x0, #1
	ldr x1, =beginning
	mov x2, #6
	svc #0

CALC_LOOP:	
	cmp x4, #15		// calculate numbers until Fn (15 in this case)
	bge 1f

	add x4, x4, #1		// increment loop counter
	
	add x3, x20, x19	// calculate next fib number
	mov x19, x20		// update addends
	mov x20, x3		

	mov x10, sp
	bl CALC_DIGITS

	b CALC_LOOP
	
1:
	mov x8, #0x40		// WRITE SYSCALL CODE
	mov x0, #1		// write mode
	ldr x1, =newline	// write the break between numbers
	mov x2, #1
	svc #0

	mov x0, x20		// EXIT SYSCALL, return last num to check
	mov x8, #0x5D
	svc #0

CALC_DIGITS:
	// Calculate Fn mod 10, store it in x3
	
	mov x6, x3		// tmp store num
	udiv x3, x3, x21	// integer dividing Fn by 10
	msub x5, x3, x21, x6 	// x5 = x6 - (x3 * x21)

	add x5, x5, #48		// turn x5 into ascii

	str x5, [sp, #-16]!	// put x5 on the stack

	cmp x3, #0
	beq 1f
	
	b CALC_DIGITS
1:
	mov x22, x30		// save return address in register (so stack isnt messed with)
	bl PRINT_NUM
	mov x30, x22		// restore save address

	ret

PRINT_NUM:
	mov x1, sp		// points to first digit
	mov x2, #1
	mov x8, #0x40		// WRITE SYSCALL CODE
	mov x0, #1		// write mode
	svc #0
	add sp, sp, #16		// move stack pointer up to next digit
	
	cmp sp, x10
	bne PRINT_NUM

	str x30, [sp, #-16]!	// store return address on stack
	bl WRITE_BREAK
	ldr x30, [sp], #16	// pop return address
	ret


WRITE_BREAK:
	mov x8, #0x40		// WRITE SYSCALL CODE
	mov x0, #1		// write mode
	ldr x1, =break		// write the break between numbers
	mov x2, #2
	svc #0

	ret


	.data

break: .ascii ", "
newline: .ascii "\n"
beginning: .ascii "0, 1, "
