;Q2:
sumNrecursion:
    sub r26, r0, r0, {C}    ;cmp r26, 0
    jle return              ;If less than or equal to zero, goto else
    add r0, r26, r1         ;r1 = N (optimised)

    callr sumNrecursion, r15
    sub r26, #1, r10        ;r10 = N-1 (optimised passing in parameter)
    add r1, r26, r1         ;r1 = sumNrecursion(N-1) + N

return:
    ret(r31)0
    xor r0, r0, r0          ;NOP (not optimisable)

main:
    callr sumNrecursion, r15
    add r0, #100, r10       ;pass in 100 (optimised)

    callr printChar, r15
    add r0, r1, r10         ;passing in result from last func call (optimised)

    ret(r31)0
    xor r0, r0, r0          ;NOP (not optimisable)


;95 register over/underflows, why?
;Because before entering main, 2 reg windows are being used up. Entering main causes a 
;3rd window to be used, and sumNrecursion(100) uses 100 windows.
;Overflow occurs whenever 8 windows are used up and there is another function call
;This program will go to a depth of 103 before returning once, and once it starts returning
;it won't make another function call meaning there are exactly 103-8=5 overflows.
;Underflows occur when there are exactly 2 register windows being occupied, and it
;tries to return. This causes it to return one of its windows and pull a window from the
;stack so that there are still 2 windows being occupied. This means that when you return
;from main, the number of underflows will be equal to the number of overflows



;Q3: 8 clock cycles with forwarding,
;    14 clock cycles without

;When implemented correctly:
;r1 = 2 + 1 = 3
;r2 = 3 + 1 = 4
;r1 = 3 + 4 = 7
;r2 = 7 + 4 = 11
;7,11 final answer

;When implemented incorrectly:
;r1 = 2 + 1 = 3
;r2 = 2 + 1 = 3
;r1 = 2 + 1 = 3
;r2 = 3 + 1 = 4
;3,4 final answer


;Q4:
1.
Page size is the max offset: 2^12 = 4kB

2. 
Page table sizes calculated as:
Primary: (2^7)*4 = 512B (Assuming each entry is 4B)
Secondary: (2^7)*4 = 512B
Tertiary: (2^6)*4 = 256B

3.
