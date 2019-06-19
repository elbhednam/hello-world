TITLE {D}	(D.asm)

;Program calculates the sum(n) using a procedure which accepts n as a value in eax
;returns the answer, sum(n) in the same register. 
;Amanda Bakalarczyk
;Assignment 4
;Problem D
;2017-10-26

INCLUDE irvine32.inc

.data

n BYTE ?

msg1 BYTE "Enter a value for n: ", 0
msg2 BYTE ", ", 0

.code
main PROC

mov edx, OFFSET msg1			; Ready message 1
call WriteString				; Display message 1
call ReadDec					; Take input for n
mov n, al						; Store value of n
call CrLf						; Next line

mov al, '{'
call WriteChar					; Print '{'
mov edx, OFFSET msg2			; Ready message 2

movzx ecx, n
dec ecx	

mov eax, 1

	L1:
		call Sum
		call WriteString
		inc eax
		loop L1

call Sum
mov al, '}'
call WriteChar					; Print '}'
call CrLf						; Next line

exit
main ENDP

;--------------------------------------------------------------------
Sum PROC USES  ecx ebx eax
; calculates the sum(n) 
; accepts n as a value in eax, and returns the answer, sum(n) in eax
;--------------------------------------------------------------------
 
 mov ecx, eax
 mov eax, 0
 mov ebx, 1
 
 L1:
	add eax, ebx
	inc ebx
	loop L1

	call WriteDec

	ret
Sum ENDP

END main