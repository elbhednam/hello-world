TITLE {C}	(C.asm)

; Program asks user for variables: A, B & C. Using these three
; Calculates the following and displays results: 
; (A * B) / (B – C)
; (B / C) – (A * B)
; 4B / 7C – 3A

;Amanda Bakalarczyk
;Assignment 5
;Problem C
;2017-11-03

INCLUDE irvine32.inc

.data

msg1 BYTE "Enter a value for C: ", 0
msg2 BYTE "Enter a value for B: ", 0
msg3 BYTE "Enter a value for A: ", 0

msg4 BYTE "(A * B) / (B - C) = ", 0
msg5 BYTE "(B / C) - (A * B) = ", 0
msg6 BYTE "4B / 7C - 3A = ", 0

num1 SDWORD ?
num2 SDWORD ?
num3 SDWORD ?

_c SDWORD ?
_b SDWORD ?
_a SDWORD ?

.code
main PROC

mov edx, OFFSET msg1			; Point to message 1
call WriteString				; Display message 1
call ReadInt					; Take input for C
mov _c, eax						; Store result in _c

mov edx, OFFSET msg2			; Point to message 2
call WriteString				; Display message 2
call ReadInt					; Take input for B
mov _b, eax						; Store result in _b

mov edx, OFFSET msg3			; Point to message 3
call WriteString				; Display message 3
call ReadInt					; Take input for A
mov _a, eax						; Store result in _a

;--------------(A * B) / (B – C)----------------------
; EDX:EAX = EAX * reg/mem32

mov eax, _a						; EAX = A
imul _b							; EAX = (A * B)
mov num1, eax					; Store (A * B) in num1

mov eax, _b						; EAX = B
sub eax, _c						; EAX = (B - C)
mov num2, eax					; Store (B - C) in num2

mov eax, num1					; EAX = (A * B)
cdq								; Extend the sign bit of EAX into EDX
idiv num2						; EAX = (A * B) / (B – C)

mov edx, OFFSET msg4			; point to message 4
call WriteString				; Display message 4
call WriteInt					; Display signed result
call CrLf						; Next line

;------------------(B / C) - (A * B)-------------------

mov eax, _b						; EAX = B
cdq								; Extend the sign bit of EAX into EDX
idiv _c							; EAX = (B / C)
mov num1, eax					; Store (B / C) in num1

mov eax, _a						; EAX = A
imul _b							; EAX = (A * B)
mov num2, eax					; Store (A * B) in num2

mov eax, num1					; EAX = (B / C)
sub  eax, num2					; EAX = (B / C) - (A * B)

mov edx, OFFSET msg5			; Point to message 5
call WriteString				; Display message 5
call WriteInt					; Display signed result
call CrLf						; Next line

;---------------------4B / 7C – 3A-----------------------

mov eax, _b						; EAX = B
mov ebx, 4						; EBX = 4
imul ebx						; EAX = 4B
mov num1, eax					; Store 4B in num1

mov eax, _c						; EAX = C
mov ebx, 7						; EBX = 7
imul ebx						; EAX = 7C
mov num2, eax					; Store 7C in num2

mov eax, num1					; EAX = 4B
cdq								; Extend the sign bit of EAX into EDX
idiv num2						; EAX = 4B / 7C
mov num3, eax					; Store 4B / 7C in num3

mov eax, _a						; EAX = A
mov ebx, 3						; EBX = 3
imul ebx						; EAX = 3A  
mov num1, eax					; Store 3A in num1

mov eax, num3					; EAX = 4B / 7C
sub eax, num1					; EAX = 4B / 7C - 3A


mov edx, OFFSET msg6			; Point to message 6
call WriteString				; Display message 6
call WriteInt					; Display signed result
call CrLf						; Next line

exit
main ENDP

END main