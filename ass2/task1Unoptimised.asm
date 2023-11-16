min3:                       ;assuming a in r10, b in r11, c in r12
    add r0, r10, r16        ;r16 = m = a

    sub r16, r11, r0, {C}   ;if (b<m) (reversed conditions)
    ;if m >= b then skip this if statement is how this is meant to work
    jle skipIf1
        xor r0, r0, r0      ;NOP
        add r0, r11, r16    ;r16 = m = b

    skipIf1:
    sub r16, r12, r0, {C}   ;if (c<m) (reversed conditions)
    ;if m >= c then skip this if statement is how this is meant to work
    jle skipIf2
        xor r0, r0, r0      ;NOP
        add r0, r12, r16    ;r16 = m = b

    skipIf2:
    add r0, r16, r10        ;move result to r1
    ret(r31)0                ;return
    xor r0, r0, r0          ;NOP

min5:
    add r0, r10, r26        ;pass in a
    add r0, r11, r27        ;pass in b
    add r0, r12, r28        ;pass in c

    callr min3, r15          ;call min3 with ret address in r15
    xor r0, r0, r0          ;NOP

    add r0, r1, r26         ;move the result into r26 to pass into function
    add r0, r13, r27        ;pass in d
    add r0, r14, r28        ;pass in f

    callr min3 r15          ;call min3
    xor r0, r0, r0          ;NOP

    ret(r31)0                ;return (final result should alrdy be in r1)
    xor r0, r0, r0          ;NOP

main:
    add r0, #100, r26       ;pass in parameter a
    add r0, #89, r27        ;pass in parameter b
    add r0, #65, r28        ;pass in parameter c
    add r0, #12, r29        ;pass in parameter d
    add r0, #32, r30        ;pass in parameter e

    callr min5, r15         ;call min5
    xor r0, r0, r0          ;NOP
    add r0, r1, r16         ;r16 = output

    sub r16, r26, r0, {C}   ;cmp out, a
    jne skipIf3             ;if not equal, skip if statement
        xor r0, r0, r0          ;NOP
        add r0, #1, r26
        callr printChar, r15    ;call function to print 1 as char
        xor r0, r0, r0          ;NOP

    skipIf3:
    sub r16, r27, r0, {C}       ;cmp out, b
    jne skipIf4                 ;if not equal, skip if statement
        xor r0, r0, r0          ;NOP
        add r0, #2, r26         ;r26 = 2
        callr printChar, r15    ;call function to print 2 as char
        xor r0, r0, r0          ;NOP

    skipIf4:
    sub r16, r28, r0, {C}       ;cmp out, c
    jne skipIf5                 ;if not equal, skip
        xor r0, r0, r0          ;NOP
        add r0, #3, r26         ;r26=3
        callr printChar, r15    ;print 3
        xor r0, r0, r0          ;NOP

    skipIf5:
    sub r16, r29, r0, {C}       ;cmp out, d
    jne skipIf6                 ;skip if not equal
        xor r0, r0, r0          ;NOP
        add r0, #4, r26         ;r26 = 4
        callr printChar, r15    ;print 4
        xor r0, r0, r0          ;NOP

    skipIf6:
    sub r16, r30, r0, {C}       ;cmp out, e
    jne skipIf7
        xor r0, r0, r0          ;NOP
        add r0, #5, r26         ;r26 = 5
        callr printChar, r15    ;print 5
        xor r0, r0, r0          ;NOP
    skipIf7:

    ret(r31)0                    ;return
    xor r0, r0, r0              ;NOP