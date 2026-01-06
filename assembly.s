        add x6, x0, x0
        addi x8, x0, 0
        addi x10, x0, 0
        addi x11, x0, 0

LOOP:   slti x7, x6, 80
        beq x7, x0, END_LOOP

        lw x9, 0(x6)

        slt x1, x8, x9
        beq x1, x0, SKIP
        add x8, x0, x9
        add x11, x0, x10

SKIP:   addi x6, x6, 4
        addi x10, x10, 1
        j LOOP

END_LOOP:

# x8  = largest element
# x11 = index of that element (0..19)