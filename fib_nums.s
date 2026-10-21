
	.global _start
	.text

_start:

	mov x19, #0		// n-1
	mov x20, #1		// n
	mov x3, x20		// n	
	mov x4, #0		// loop var
LOOP:	
	cmp x4, #8		// calculate numbers until the F9, the 10th number (base case 2 + #8)
	bge 1f

	add x4, x4, #1		// increment loop counter
	
	add x3, x20, x19		// calculate next fib number
	mov x19, x20		// update addends
	mov x20, x3		
	
	b LOOP
	
1:
	mov x0, x20		// EXIT SYSCALL, return last num to check
	mov x8, #0x5D
	svc #0

WRITE:
        mov x8, #0x40           // WRITE SYSCALL
        mov x0, #1              // write mode
        // REMINDER --------- must put the string in x1 and the buffer length in x2
	svc #0
        ret
