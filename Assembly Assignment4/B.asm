TITLE {B}	(B.asm)

;Program asks the user for a lower number and an upper number. 
;Procedure generates a random number from the lower number to upper number.
;Amanda Bakalarczyk
;Assignment 4
;Problem B
;2017-10-25

INCLUDE irvine32.inc

.data

msg1 BYTE "Enter a lower number: ", 0
msg2 BYTE "Enter an upper number: ", 0

.code
main PROC

call Randomize

mov ecx, 5						; Set loop count to five

L1:
	mov edx, OFFSET msg1			; Point to message 1
	call WriteString				; Display message 1
	call ReadInt					; Take input
	xchg ebx, eax					; move input to ebx
	call CrLf						; Next line

	mov edx, OFFSET msg2			; Point to message 2
	call WriteString				; Display message 2
	call ReadInt					; Take input
	call CrLf						; Next line
	call BetterRandomRange			; Call procedure
	call CrLf						; Next line
	loop L1


exit
main ENDP

;-----------------------------------------------------
BetterRandomRange PROC USES eax ebx
;generates an integer between M and N-1.
;-----------------------------------------------------

sub eax, ebx					; Subtract lower range from upper range
call RandomRange
add eax, ebx					; Add the lower range to the generated random

call WriteInt
call CrLf
				
	ret
BetterRandomRange ENDP
END main