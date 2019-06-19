TITLE LetterMatrix         (LetterMatrix.asm)
; Creates a 4 x 4 matrix of uppercase letters
; Amanda Bakalarczyk
; COSC 2406
; Assignment 8, Q3
; 2017-11-26

INCLUDE Irvine32.inc

.data

NUM_ROWS = 4
NUM_COLS = 4
array DWORD NUM_ROWS * NUM_COLS DUP(?)
vowels BYTE "AEIOU", 0
consonants BYTE "BCDFGHJKLMNPQRSTVWXYZ", 0

randomLetter PROTO,
vowArray : PTR BYTE,
conArray : PTR BYTE

.code
main PROC

call Randomize
mov ecx, 5													; Set loop counter for printing 5 matrices

L:
push ecx													; Save loop counter
mov esi, 0													; Clear esi and edi
mov edi, 0
mov ecx, NUM_ROWS											; Set loop counter to columns

L1:

push ecx													; Save row loop counter
mov edi, 0													; Clear edi
mov ecx, NUM_COLS											; Set loop counter to column number

L2:

INVOKE randomLetter, ADDR vowels, ADDR consonants			; Call the procedure
mov array[esi + edi], eax									; move the random character in eax to the array index
add edi, TYPE array											; Increment columns
loop L2														; Continue L2
pop ecx														; Restore row loop counter
add esi, NUM_COLS * TYPE array								; Increment rows
loop L1														; Continue L1

push NUM_COLS												; Push column number on the stack
push NUM_ROWS												; Push row number on the stack
push OFFSET array											; Push the offset of array on the stack
call printArray												; Print the matrix
call CrLf													; Next line
pop ecx														; Restore original ecx value to print matrix 5 times total
loop L														; Continue first loop

exit
main ENDP

;•*´¨`*•.¸¸.•*´¨`*•.¸¸.•*´¨`*•.¸¸.•*´¨`*•.¸¸.•
;*********************************************
randomLetter PROC USES edx,
vowArray : PTR BYTE,
conArray : PTR BYTE
;*********************************************
;•*´¨`*•.¸¸.•*´¨`*•.¸¸.•*´¨`*•.¸¸.•*´¨`*•.¸¸.•

mov eax, 2						; Create random range from 0 - 1
call RandomRange						
cmp eax, 0						; Is eax 0 or 1?
je Vowel						; If it's 0, generate a random vowel, else generate consonant

mov edx, conArray				; Point edx to array of consonants
mov eax, 21						; move the consonant range to eax
call RandomRange
add edx, eax					; Get random index for consonant array
mov al, BYTE PTR[edx]		; Place value at array index in al
jmp Next						; Exit procedure

Vowel:

mov	edx, vowArray				; edx has the offset of the vowel array
mov	eax, 5						; eax = length of vowel array 
call RandomRange
add	edx, eax					; Get random index for vowel array
mov	al, BYTE PTR [edx]			; Place random letter in al

Next:
ret
randomLetter ENDP

;•*´¨`*•.¸¸.•*´¨`*•.¸¸.•*´¨`*•.¸¸.•*´¨`*•.¸¸.•
;*********************************************
printArray PROC,
	arrayPtr : PTR DWORD,
	nRows : DWORD,
	nCols : DWORD
;*********************************************
;•*´¨`*•.¸¸.•*´¨`*•.¸¸.•*´¨`*•.¸¸.•*´¨`*•.¸¸.•

mov esi, arrayPtr				; Move the offset of the array to esi
mov edi, 0						; Clear edi
mov ecx, nRows					; Set loop counter to the number of rows

L1:
push ecx						; Save ecx
mov edi, 0						; Clear edi
mov ecx, nCols					; Set loop counter to number of columns

L2:
mov eax, [edi + esi]			; Move array element to eax
call WriteChar					; Display array element
mov al, ' '						; Put a space in al
call WriteChar					; Write a space
add edi, TYPE DWORD				; Increment column
loop L2							; Continue L2

pop ecx							; Restore original loop counter
call CrLf						; New line
add esi, edi					; Increment row
loop L1							; Continue L1

ret 
printArray ENDP
END main