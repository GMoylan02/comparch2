;#include <stdio.h>
;int my_fact(int N)
;{
;	if(N>0)
;		return(N*my_fact(N-1));
;	else
;		return(1);
;}
;int main()
;{
;	printf("%d\n",my_fact(5));
;	return 0;
;}

;assuming N is in r26
my_fact:
    sub r26, r0, r0, {C}    ; cmp N, 0
    jle return              ; if N <= 0, skip the if statement and return 1
    add r0, #1, r1          ; return value = 1 (optimised)

    callr my_fact, r15      ;r1 = my_fact(N-1)
    sub r26, #1, r10        ; pass in N-1 (optimised)

    add r1, r0, r10         ;r10 = my_fact(N-1) to pass into imul
    callr imul, r15         ;r1 = imul(r10, r11)
    add r26, r0, r11        ;pass in r11 for imul (optimised)

return:
    ret(r31)0
    xor r0, r0

main:
    callr my_fact r15       ;call my_fact(5)
    add r0, #5, r10         ;pass in 5 for the function above(optimised)

    callr printChar, r15    ;print r10 (which is my_fact(5))
    add r1, r0, r10         ;r10 = result from my_fact(5) (optimised)

    ret(r31)0               ;return
    xor r0, r0, r0          ;NOP

;1 overflow and 1 underflow once it returns from main. why?
;because it will enter main and 3 reg banks will be used.
;my_fact will recurse until n = 0 so it should be called 6 times before it starts returning
;only on the 9th and last call will it overflow
;underflow occurs when returning and there are only 2 reg windows. cant drop below 2 reg windows so it has to pull a reg window out
;of the stack before returning so it will underflow once upon returning from main.