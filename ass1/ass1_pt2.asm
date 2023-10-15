.data
output db "Hello, World!"
output2 db "Helooo world!"

minus DQ 45	; ascii code for '-'

tmp DQ ?

.code

my_int2str PROC
	; creating stack frame
	push rbp
	mov rbp, rsp
	; local variables
	sub rsp, 24
	push rbx	; preserve rbx
	
	mov rax, 10
	mov [rbp-8], rax	; int tens = 10
	mov rax, 0
	mov [rbp-16], rax	; int remainder = 0;
	mov rax, rcx
	mov [rbp-24], rax	; store num on the stack

	; checking for negative numbers
	
	mov rax, [rbp-24]	; rax = num
	shl rax, 1		; num << 1
	jnc else1		; if carry (reversed conditions)

	mov rcx, OFFSET minus	; 1st arg for print
	mov rdx, 1		; 2nd arg (# Bytes)
	;; syscall to print
	mov rax, 4
	mov rbx, 1
	int 80h
		
	mov rax, [rbp-24]	; rax = num
	mov rdx, 0bFFFFFFFFh	; rdx = mask
	xor rax, rdx		; invert num
	add rax, 1		; increment rax
	mov [rbp-24], rax	; turn num from negative to positive (if negative)
else1:	
	while1:
		xor rax, rax		; clear rax
		mov eax, [rbp-24]	; eax = num
		xor rdx, rdx		; clear rdx
		mov ecx, [rbp-8]	; ecx = tens	(16 bits)
		div ecx			; eax = eax / ecx	(nums / tens)
		cmp eax, 10		; if (num / tens >= 10)
		jl endWh1		; 
	
		mov rax, [rbp-8]	; rax = tens
		mov rdx, 10
		mul rdx			; rax = tens * 10;
		mov [rbp-8], rax	; store tens back on the stack

		jmp while1
	endWh1:

	xor rdx, rdx			; clearing rdx
	mov ecx, [rbp-8] 		; dx = tens
	xor eax, eax			; clear eax
	mov eax, [rbp-24]		; eax = num
	div ecx				; eax = num / tens, remainder in edx
	mov [rbp-24], rax		; store nums on stack
	mov [rbp-16], rdx		; remainder = dx
	
	while2:
		mov rdx, [rbp-8]	; rdx = tens
		cmp rdx, 1		
		je endWh2		; while tens != 1

		mov rcx, [rbp-24]	; rcs = num
		add rcx, 48
		mov tmp, rcx

		mov rcx, OFFSET tmp	; 1st arg for print (num)

		mov rdx, 1		; 2nd arg (# Bytes)
		;; syscall to print
		mov rax, 4
		mov rbx, 1
		int 80h

		mov rcx, [rbp-16]	; rcx = remainder
		mov [rbp-24], rcx	; num = remainder
		xor rax, rax		; clear rax
		xor rcx, rcx		; clear rcx
		mov eax, [rbp-8]	; eax = tens
		xor rdx, rdx		; clear rdx
		mov ecx, 10		; ecx = 10 (tmp value)

		div ecx			; tens  = tens / 10;
		mov [rbp-8], rax	; store tens

		mov rax, [rbp-8]	; rax = tens
		cmp rax, 1
		jne else2		; if tens == 1
			mov rcx, [rbp-24]	; rcx = nums
			add rcx, 48
			mov tmp, rcx

			mov rcx, OFFSET tmp	; 1st arg for print (num)

			mov rdx, 1		; 2nd arg (# Bytes)
			;; syscall to print
			mov rax, 4
			mov rbx, 1
			int 80h
	else2:
		xor rdx, rdx		; clear rdx
		xor rax, rax		; clear rax
		xor rcx, rcx		; clear rcx
		mov ecx, [rbp-8]	; ecx = tens
		mov eax, [rbp-24]	; eax = num
		div ecx			; rax = num / tens
		mov [rbp-24], rax	; store nums
		mov [rbp-16], rdx	; store remainder
		jmp while2
	endWh2:

	;; syscall to exit
	mov rax, 1
	mov rbx, 0		;
	int 80h
	pop rbx
	add rsp, 24
	pop rbp

	ret 0

my_int2str ENDP	
	
_start:
	mov rcx, 456		; 1st arg
	sub rsp, 32		; shadow space
	call my_int2str
	add rsp, 40		; align stack
end _start

; Below is c code I wrote first with all the functionality except 
; it can't handle negative numbers like the asm above can

;int main() {
;    int_2str(207655);
;    return 0;
;}
;void int_2str(long long num){
;    long long tens = 10;
;    long long remainder = 0;
;    while ((num / tens) >= 10){
;        tens *= 10;
;    }
;    remainder = num % tens;
;    num /= tens;
;    while (tens != 1){
;        printf("%d", num);
;        num = remainder;
;        tens /= 10;
;        if (tens == 1){
;            printf("%d", num);
;        }
;        remainder = num % tens;
;        num /= tens;
;    }
;}
	
