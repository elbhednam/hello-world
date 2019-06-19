TITLE {A}	(A.asm)

; Crazy art is crazy
; Amanda Bakalarczyk
; Assignment 5
; Problem A
; 2017-11-04

INCLUDE irvine32.inc

.data

msg BYTE " ", 0
msg1 BYTE "Enter an upper or lowercase character: ", 0

clr1 BYTE "(0 - Black, 1 - Blue, 2 - Green, 3 - Cyan, 4 - Red, 5 - Magenta, ", 0
clr2 BYTE "6 - Brown, 7 - Light Gray, 8 - Gray, 9 - Light Blue, 10 - Light Green, ", 0
clr3 BYTE "11 - Light Cyan, 12 - Light Red, 13 - Light Magenta, 14 - Yellow, 15 - White)", 0

msg2 BYTE "Enter a colour number for the border: ", 0
msg3 BYTE "Enter a colour number for the background: ", 0
msg4 BYTE "Enter a colour number for the foreground: ", 0

symbol BYTE ?
borderColour BYTE ?
colour BYTE ?
bg BYTE ?
fg BYTE ?
numRows = 20
numCols = 60


.code
main PROC

;--------------Ask the user for a character-------------------------

mov edx, OFFSET msg1						; Point to message 1
call WriteString							; Display message 1
call ReadChar								; Take input
call WriteChar								; Display the character
mov symbol, al								; Store input in symbol variable
call CrLf									; Next line
mov edx, OFFSET msg							
call WriteString							; Create blank line
call CrLf									; Next line

;---------------Display Colour Options-------------------------------

mov edx, OFFSET clr1						; Point to clr1
call WriteString							; Display colour options
call CrLf									; Next line

mov edx, OFFSET clr2						; Point to clr2
call WriteString							; Display colour options
call CrLf									; Next line

mov edx, OFFSET clr3						; Point to clr3
call WriteString							; Display colour options
mov edx, OFFSET msg	
call CrLf									; Next line
call WriteString
call CrLf

;----------------------Create Border Colour-----------------------------------

mov edx, OFFSET msg2						; Point to message 2
call WriteString							; Display message 2
call ReadDec								; Take input for border colour
xchg ah, al
mov al, ah

call combineColour

mov borderColour, al						; Store eax in borderColour


;------------------Ask the user for the background/foreground colours--------------------------

mov edx, OFFSET msg							; Point to message
call CrLf									; Next line
call WriteString							; Display blank
call CrLf									; Next line

mov edx, OFFSET msg3						; Point to message 3
call WriteString							; Display message 3
call ReadDec								; Take input for background colour
xchg ah, al									; Store al as background colour
mov edx, OFFSET msg							; Point to message
call CrLf									; Next line
call WriteString							; Display blank
call CrLf									; Next line

mov edx, OFFSET msg4						; Point to message 4
call WriteString							; Display message 4
call ReadDec								; Take input for foreground colour

call combineColour
mov colour, al								; Store colour
call GetTextColor
push eax									; Save the current text colour on the stack

mov edx, OFFSET msg							; Point to message
call CrLf									; Next line
call WriteString							; Display blank
call CrLf									; Next line


;---------------Make the border box, do the crazy art---------------------------

mov eax, 0									; Clear eax
mov edi, numRows							; edi = 20
mov esi, numCols							; esi = 60
mov al, borderColour						; Move border colour to al
mov edx, OFFSET symbol						; Point edx to symbol
call makeBorderBox							


mov ecx, 5000								; Set loop counter to 5000

L1:
	
	mov al, colour							; Move colour variable to al
	call SetTextColor						; Set text colour using value stored in colour variable
	call randomXYPosition					; Get random x,y position
	call Gotoxy								; Locate cursor		
	inc colour								; Advance the colour
	mov al, symbol							; Move symbol variable to al
	call WriteChar							; Print the symbol
	call advanceSymbol						; Advance the symbol
	mov symbol, al							; Save the new symbol value
	loop L1									; Continue 
	
pop eax										; Restore original text colour				
call SetTextColor							; Set text colour
mov dh, 22									; row 22
mov dl, 0									; column 0
call Gotoxy									; Locate cursor

exit
main ENDP

;************************************************************
betterRandomRange PROC USES ebx
; Receives: EAX = high number; EBX = low number
; Returns: EAX = random number from low to high
;************************************************************

sub eax, ebx					; Subtract lower range from upper range
inc eax							; Add 1
call RandomRange
add eax, ebx					; Add the lower range to the generated random

ret
betterRandomRange ENDP

;************************************************************
combineColour PROC
; Receives: AH = background Colour, AL = foreground Colour
; Returns: AL = 16* background + foreColour
;************************************************************


shl ah, 4									; Shift background colour
add ah, al									; Add foreground colour
mov al, ah
shr ax, 8									; shift everything into al
	
ret
combineColour ENDP

;************************************************************
makeBorderBox PROC USES ecx edx edi esi
; Creates a coloured box in the borderColour (al) with a
; width and height defined in esi and edi starting at
; cursor position 0,0
; Receives: ESI = width of border box numCols
; EDI = height of border box numRows
; AL = border colour
; Return: none
;************************************************************

call SetTextColor
mov dh, 0							; row 0
mov dl, 0							; column 0
call Gotoxy							; Locate cursor
mov ecx, edi						; set outer loop count

L1:
	push ecx						; save outer loop count
	mov ecx, edi 					; set inner loop count
L2:
	call WriteString				; Display border colour
	loop L2							; repeat the inner loop
	pop ecx							; restore outer loop count
	call CrLf
	loop L1							; repeat the outer loop

	call CrLf

ret
makeBorderBox ENDP

;************************************************************
randomXYPosition PROC USES eax ebx esi edi
; Generates a random (x,y) coordinate position for the
; cursor within a box defined with a width in esi and
; a height in edi with an offset border of two on the top
; and 3 on the sides
; Receives: ESI = width of border box
; EDI = height of border box
; Return: DH = row position (y)
; DL = column position (x)
;************************************************************

sub esi, 4
sub edi, 3

mov ebx, 3						; Low range of 3
mov eax, esi					; Upper range of numCols - 4
call betterRandomRange			; Returns x value in eax
mov dl, al						; Store x value in dl
mov ebx, 2						; Low range of 2
mov eax, edi					; Upper range of numRows - 3
call betterRandomRange			; Returns y value in eax
mov dh, al						; Store y value in dh

ret
randomXYPosition ENDP

;************************************************************
advanceSymbol PROC 
; Advances the symbol within the range 32 - 157
; Receives: AL = symbol value
; Return: AL = new symbol value
;************************************************************

cmp al, 33						; Compare al to 32
jb L1							; Jump if below to L1
cmp al, 126						; Compare al to 157
ja L1							; Jump if above to L1
inc al							; Otherwise increment al
jmp next						; Exit the procedure

L1:
mov al, 33						; Reset al to 32

next:							; Exit the procedure

ret
advanceSymbol ENDP
END main