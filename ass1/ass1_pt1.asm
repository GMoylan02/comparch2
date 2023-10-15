include \masm32\include\masm32rt.inc
.486
.data
.code

my_sum3 PROC
    push ebp
    mov ebp, esp
    sub esp, 4              ; local variable space (x)
    push ebx                ; Preserving ebx to use as a tmp register
    push ecx                ; same for ecx

    xor ebx, ebx            ; initialise ebx to 0
    mov [ebp-4], ebx        ; store x (0) at ebp-4

    mov ebx, [ebp+8]        ; ebx = a
    cmp ebx, 0
    jg else1                 ; if a <= 0 (reversed conditions to skip if block)
        mov eax, [ebp-4]    ; eax = x
        pop ecx             ; restore ecx
        pop ebx             ; restore ebx
        add esp, 4         ; clear local variables
        pop ebp             ; restoring ebp
        ret 0  
           
else1:
    mov ebx, [ebp+8]        ; ebx = a
    mov [ebp-4], ebx        ; x = a
    sub ebx, 1         ; a--
    mov [ebp+8], ebx        ; store 'a' on the stack

    mov ebx, [ebp+12]       ; ebx = b
    cmp ebx, 0              
    jl else2                ; if b >= 0 (reversed conditions)
        mov ecx, [ebp-4]    ; ecx = x
        add ecx, ebx        ; x = x + b
        mov [ebp-4], ecx    ; store 'x' on the stack
        sub ebx, 1          ; b--
        mov [ebp+12], ebx   ; store 'b' on the stack
    
else2:
    mov ebx, [ebp+16]       ; ebx = c
    cmp ebx, 0  
    jl else3                ; if c >= 0 (reversed conditions)
        mov ecx, [ebp-4]    ; ecx = x
        add ecx, ebx        ; x = x + c
        mov [ebp-4], ecx    ; store 'x' on the stack
        sub ebx, 1          ; c--
        mov [ebp+16], ebx   ; store 'c' on the stack
    
else3:
    mov ebx, [ebp+16]       ; ebx = c
    push ebx                ; pass in c
    mov ebx, [ebp+12]       ; ebx = b
    push ebx                ; pass in b
    mov ebx, [ebp+8]        ; ebx = a
    push ebx                ; pass in a

    mov ebx, [ebp-4]        ; ebx = x

    call my_sum3

    add esp, 12             ; clearing the stack

    add eax, ebx       ; return value from last call += x
    pop ecx
    pop ebx
    add esp, 4              ; clearing local variables

    pop ebp                 ; restoring ebp
    
    ret 0 
my_sum3 ENDP

    
my_sum3_wrapper PROC
    push ebp
    mov ebp, esp
    push ebx

    mov ebx, [ebp+8]    ;ebx = N
    sub ebx, 2          ;ebx -= 2
    push ebx            ;Pass in parameter c

    mov ebx, [ebp+8]    ; ebx = N
    sub ebx, 1          ; ebx =- 1
    push ebx            ; pass in parameter b

    mov ebx, [ebp+8]    ; ebx = N
    push ebx            ; pass in parameter a
    call my_sum3        ; call function, output should be in eax

    add esp, 12          ; clearing the stack

    pop ebx
    pop ebp             ; restoring ebp
    ret 0
    my_sum3_wrapper ENDP

main:
    push ebp
    mov ebp, esp 
    push ebx

    mov ebx, 57          ; int N = ...
    push ebx
    call my_sum3_wrapper; 
    add esp, 4          ; clearing the stack

    print str$(eax)

    ret 0
end main
    
    
    
    
