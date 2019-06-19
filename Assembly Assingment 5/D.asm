TITLE {D}	(D.asm)
; Program asks for value between 0 and 99, displays a message if the number is invalid
; Otherwise calls a procedure to convert unsigned 8-bit binary value in decimal format.
;Amanda Bakalarczyk
;Assignment 5
;Problem D
;2017-11-03

INCLUDE irvine32.inc

.data

msg1 BYTE "Enter a number between 0 and 99: ", 0
msg2 BYTE "The number is invalid.", 0

num BYTE ?

.code
main PROC

mov edx, OFFSET msg1				; Point to message 1
call WriteString					; Display message 1
call ReadInt						; Take user input
call CrLf							; Next line

mov ebx, 0
mov edx, 99

cmp eax, ebx						; If num >= 0
jb L1								; Jump if below to 'invalid number' message
cmp eax, edx						; If num >= 99
ja L1								; Jump if above to 'invalid number' message
call showDecimal8					; Call procedure
call CrlF							; Next line
jmp Next

L1:
	mov edx, OFFSET msg2			; Point to message 2
	call WriteString				; Display message 2
	call CrLf	

Next:

exit
main ENDP

;************************************************************
showDecimal8 PROC
; Receives: AL
; Returns: Nothing
;************************************************************

mov bl, 10					
div bl								; Divide by 10, ah = remainder, al = quotient
OR ax, 00110000b					; Set bits 4 and 5 to get ascii value
call WriteChar						; Display quotient
shr ax, 8							; Shift ah into al
OR ax, 00110000b					; Set bits 4 and 5 to get ascii value
call WriteChar						; Display remainder
call CrLf							; Next line

ret
showDecimal8 ENDP

END main