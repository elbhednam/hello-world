TITLE {Assignment6}	(Assignment6.asm)

; Program with an array of 8 SWORDS initialized with all zeros. 
; Displays choice menu, calls procedures based on choice
; Amanda Bakalarczyk
; Assignment 6
; 2017-11-17

INCLUDE irvine32.inc

.data

msg1 BYTE "1 - Populate the array with random numbers", 0
msg2 BYTE "2 - Multiply the array with a user provided multiplier", 0
msg3 BYTE "3 - Divide the array with a user provided divisor", 0
msg4 BYTE "4 - Print the array", 0
msg0 BYTE "0 - Exit", 0

msg5 BYTE "The array has been populated with random values between -500 and +2000", 0
msg6 BYTE "Please provide the multiplier required for the operation: ", 0
msg7 BYTE "All array elements have been multiplied by ", 0
msg8 BYTE "Please provide the divisor for the required operation: ", 0
msg9 BYTE "Divisor must not be zero", 0
msg10 BYTE "All array elements have been divided by ", 0


array SDWORD 8 DUP(0)
m SDWORD ?					
d SDWORD ?
colour DWORD ?

.code
main PROC

mov eax, green + (black shl 4)
call SetTextColor
call GetTextColor
mov colour, eax

L: 

mov edx, OFFSET msg1						; Display choice menu
call WriteString
call CrLf
mov edx, OFFSET msg2
call WriteString
call CrLf
mov edx, OFFSET msg3
call WriteString
call CrLf
mov edx, OFFSET msg4
call WriteString
call CrLf
mov edx, OFFSET msg0
call WriteString
call CrLf

call readDec								; Take input for choice
cmp eax, 0									; Compare to zero
jz Next										; Exit if zero
cmp eax, 1									; Compare to 1
jz L1										; If zero, go to option 1
cmp eax, 2									; Compare to 2
jz L2										; If zero, go to option 2
cmp eax, 3									; Compare to 3
jz L3										; If zero, go to option 3
cmp eax, 4									; Compare to 4
jz L4										; If zero, go to option 4
jmp Next									; Exit otherwise

;----------------------Option 1---------------------------------

L1:

push OFFSET array							; Push address of array
push LENGTHOF array							; Push length of array
call Randomize
call populateRandomNum						; Call procedure

mov eax, yellow + (black shl 4)				; Set text to yellow
call SetTextColor
mov edx, OFFSET msg5						; Point to message 5
call WriteString							; Display message 5
call CrLf									; Next line
mov al, " "
call WriteChar
call CrLf
mov eax, colour								; Reset text colour
call SetTextColor
jmp L										; Back to choice menu

;----------------------Option 2----------------------------------

L2:
mov eax, lightGray + (black shl 4)			; Set text colour to white
call SetTextColor
mov edx, OFFSET msg6						; Point to message 6
call WriteString							; Display message asking for multiplier
call ReadInt								; Take input for multiplier
mov m, eax									; Store multiplier
call CrLf									; Next line
push OFFSET array							; Push array address
push eax									; Push multiplier
call multiplyArray							; Call procedure

call CrLf
mov eax, yellow + (black shl 4)
call SetTextColor
mov edx, OFFSET msg7						; Point to message 7
call WriteString							; Display message 7
mov eax, m
call WriteInt								; Display multiplier
call CrLf
mov al, " "
call WriteChar
mov eax, colour
call SetTextColor
call CrLf

jmp L										; Back to choice menu

;----------------------Option 3----------------------------------

L30:
mov eax, red + (black SHL 4)				; Set text to the colour associated with danger
call SetTextColor
mov edx, OFFSET msg9						; Point to message 9
call WriteString							; Display 'divisor must not be zero' message
call CrLf
mov al, " "
call WriteChar
mov eax, colour								; Reset the text colour
call SetTextColor
call CrLf

L3:
mov eax, lightGray + (black shl 4)			; Set text colour to white
call SetTextColor
mov edx, OFFSET msg8						; Point to message 8
call WriteString							; Display message asking for divisor
call ReadInt								; Take input for divisor
mov d, eax									; Store divisor
cmp eax, 0									; Check if divisor is zero
je L30										; 
mov esi, OFFSET array						; Point esi to array
mov ecx, LENGTHOF array						; Set loop counter to array length

L3a:
push d										; Push the divisor on the stack
push [esi]									; Push array element on the stack
call divideArray							; Call the procedure
mov [esi], eax								; Replace array element with value returned in eax
mov eax, 0									; Clear eax
add esi, TYPE DWORD							; Go to the next array element
loop L3a									; Continue the loop

call CrLf
mov eax, yellow + (black shl 4)				; Set text colour to yellow
call SetTextColor
mov edx, OFFSET msg10						; Point to message 10
call WriteString							; Display message 10
mov eax, d
call WriteInt								; Display divisor
call CrLf
mov al, " "
call WriteChar
mov eax, colour								; Reset text colour
call SetTextColor
call CrLf

N:
jmp L										; Back to choice menu

;----------------------Option 4----------------------------------

L4:

mov eax, yellow + (black shl 4)				; Set text colour to white
call SetTextColor
printArray PROTO,							; Create procedure prototype
arrayOffset : SDWORD,						; Named parameters
arrayLength : DWORD
INVOKE printArray,							; push parameters and call procedure
OFFSET array, 
LENGTHOF array
mov eax, colour								; Reset text colour
call SetTextColor
jmp L										; Back to choice menu

Next:

exit
main ENDP

;************************************************************
populateRandomNum PROC
; Fills array with random values from -500 to 2000
; Recieves: OFFSET array, LENGTHOF array as stack parameters
; Returns: Nothing. 
;************************************************************

push ebp								; Push ebp
mov ebp, esp							; Point ebp to the top of the stack
sub esp, 8								; Make room for two local variables
pushad									; Save registers
mov esi, [ebp + 12]						; Move offset of array to esi
mov ecx, [ebp + 8]						; Move array length to ecx
mov DWORD PTR [ebp - 4], -500			; Low number
mov DWORD PTR [ebp - 8], 2000			; High number

L1: 
	mov eax, [ebp - 8]					; Move high number to eax
	sub eax, [ebp - 4]					; Subtract low number from high number		
	inc eax								
	call RandomRange
	add eax, [ebp - 4]					; Range = high - low + 1
	mov [esi], eax						; Move the random to the array
	add esi, TYPE DWORD
	loop L1								; Continue

popad									; Restore registers
mov esp, ebp							; Remove locals from stack
pop ebp									; Restore ebp
ret 8									; Clear parameters from stack
populateRandomNum ENDP

;************************************************************
multiplyArray PROC
; Modifies array by multiplying all values by a stack parameter
; Recieves: OFFSET array, multiplier as stack parameters
; Returns: Nothing.
;************************************************************

ENTER 4, 0				
mov esi, [ebp + 12]						; Move offset of array to esi
mov ebx, [ebp + 8]						; Move multiplier to eax
mov DWORD PTR [ebp - 4], 8				; Assign value of 8 to local variable
mov ecx, [ebp - 4]						; Use local variable as loop counter

L1:
mov eax, [esi]							; Move array element to eax
imul ebx								; Multiply by ebx
mov [esi], eax							; Create new array element (eax * ebx)
add esi, TYPE DWORD						; Move to next array element
loop L1									; Continue loop

LEAVE									; Restore all the things
ret 8									; Clear parameters from the stack
multiplyArray ENDP

;************************************************************
divideArray PROC,
arrayElement : SDWORD,
divisor : SDWORD
; Receives: array element and divisor as SDWORD stack parameters
; Returns: value of quotient in eax
;************************************************************
push ebx								; Push ebx on the stack

mov eax, arrayElement					; Move [ebp + 8] to eax
cdq										; Extend the sign bit of EAX into EDX:
mov ebx, divisor						; Move [ebp + 12] to ebx
idiv ebx								; eax /= ebx

pop ebx									; Pop ebx off the stack
ret 8									; Clear parameters from the stack
divideArray ENDP

;************************************************************
printArray PROC USES esi eax ecx,
arrayOffset : SDWORD,
arrayLength : DWORD
; Prints array elements
; Receives: Array offset and length as stack parameters
; Returns: Nothing
;************************************************************

mov esi, arrayOffset					; Point esi to array
mov ecx, arrayLength					; Set loop counter to length of array
dec ecx							
mov eax, '['
call WriteChar							; Display open bracket

L1:
mov eax, [esi]							; Move array element to eax
call WriteInt							; Display array element
mov eax, ','
call WriteChar							; Display comma
mov eax, ' '
call WriteChar							; Display space
add esi, TYPE DWORD						; Move to next array element
loop L1									; Continue loop

mov eax, [esi]							; Move last element to eax
call WriteInt							; Display last element
mov eax, ']'
call WriteChar							; Display close bracket
call CrLf
mov eax, ' '
call WriteChar
call CrLf

ret
printArray ENDP

END main