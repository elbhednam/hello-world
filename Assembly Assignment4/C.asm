TITLE {C}	(C.asm)

;Collection of separate procedures which fill an array with random numbers
;displays array, sum of values, count of positive values, and largest number
;Amanda Bakalarczyk
;Assignment 4
;Problem C
;2017-10-25

INCLUDE irvine32.inc

.data

array1 SWORD 30 DUP(?)

msg1 BYTE "The array has been filled with values in the range -4A3Eh to +5B2Dh.", 0
msg2 BYTE "h, ", 0
msg3 BYTE "The total of the values in the array is ", 0
msg4 BYTE "The number of positive values in the array is ", 0
msg5 BYTE "The largest number in the array in binary is ", 0

.code
main PROC

	mov esi, OFFSET array1		; esi points to beginning of array
	mov ecx, LENGTHOF array1	; loop counter set to number of elements in array
	mov ebx, TYPE array1		

	call InitializeRandom
	mov edx, OFFSET msg1		; Ready message 1
	call WriteString			; Display message 1
	call CrLf					; Next line
	
	mov edx, OFFSET msg2		; Ready message 2
	call DisplayHex
	call CrLf					; Next line

	mov edx, OFFSET msg3		; Ready message 3
	call WriteString			; Display message 3
	call SumValues
	call CrLf					; Next line

	mov edx, OFFSET msg4		; Ready message 4
	call WriteString			; Display message 4
	call countPos
	call CrLf

	mov edx, OFFSET msg5		; Ready message 5
	call WriteString			; Display message 5
	call LargestBin
	call CrLf					; Next line

	exit
main ENDP

;----------------------------------------------------------------
InitializeRandom PROC USES eax ecx edx 
; Fills array with random integers in the range -4A3Eh to +5B2Dh.
; Reports when finished
;----------------------------------------------------------------

	L1: 
		mov eax, 0A56Ch			; Get random 0 to A56C
		sub eax, 0B5C2h			; Subtract lower range from A56C
		call RandomRange		; Call library function
		add eax, 0B5C2h			; Make range -4A3Eh to +5B2Dh 
		mov eax, [esi]			; Add random to array
		add esi, ebx			; increment esi
		loop L1					; Continue loop

	call Randomize

	ret
InitializeRandom ENDP

;---------------------------------------------------------
DisplayHex PROC USES eax ecx
; Loops through the array and displays each number in HEX
;---------------------------------------------------------

	mov al, '['
	call WriteChar				;Print '['
	mov eax, 0
	dec ecx

	L1:
		movsx eax, WORD PTR [esi]			
		call WriteHexB				;Display array element
		call WriteString			;Display msg
		add esi, ebx				;Increment esi 
		loop L1 					;Continue loop

	movsx eax, WORD PTR [esi]
	call WriteHexB
	mov al, 'h'
	call WriteChar
	mov al, ']'					;Print ']'
	call WriteChar
	call CrLf

	ret
DisplayHex ENDP

;---------------------------------------------------------
SumValues PROC USES eax ecx
; Sums all the values in the array
; Reports total as signed integer
;---------------------------------------------------------

mov eax, 0

	L1:
		add eax, [esi]				; Add array item to eax
		add esi, ebx				; Increment esi
		loop L1						; Continue L1

	call WriteInt					; Report sum

	ret
SumValues ENDP

;---------------------------------------------------------
CountPos PROC USES eax ecx
; Counts the positive integers 
; Reports count as unsigned integer
;---------------------------------------------------------

mov eax, 0

L1:
	jns L2								; Jump if the sign flag is not set
	add esi, ebx						; increment esi
	loop L1								; Continue
	jmp Done
L2:
	inc eax								; Increment the count if sign flag not set
	loop L1								; Continue looping to count positive integers

Done:
	call WriteDec						; Display result
	ret
CountPos ENDP

;---------------------------------------------------------
LargestBin PROC USES eax ecx
; Reports largest number in array as 16-bit binary value
;---------------------------------------------------------

mov eax, 0

L1:
	cmp WORD PTR [esi], ax				; Compare element of esi to ax
	jge L2								; Jump if greater or equal
	add esi, ebx						; increment esi
	loop L1								; Continue searching for largest element
	jmp Done							
L2:
	movsx eax, WORD PTR[esi]			; Move element in esi to eax
	loop L1								; Continue searching for a larger element

Done:
	call WriteHexB						; Print the result
	ret
LargestBin ENDP

END main