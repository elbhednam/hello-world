TITLE {B}	(B.asm)

; Program populates array with random numbers
; Calls procedure to sum values in array with values between variables j and k inclusive, displays results

; Amanda Bakalarczyk
; Assignment 5
; Problem B
; 2017-10-29

INCLUDE irvine32.inc

.data

msg BYTE ", ", 0
msg0 BYTE " ", 0 
msg1 BYTE "Enter the value for 'j': ", 0
msg2 BYTE "Enter the value for 'k': ", 0 
msg3 BYTE "The sum of values between j and k is: ", 0

j DWORD ?
k DWORD ?

array DWORD 100 DUP(?)
arraySize = ($ - array) / TYPE array

.code
main PROC

mov esi, OFFSET array						; Point to the beggining of the array
mov ecx, arraySize							; Set loop counter to array length
call Randomize
call initializeRandom						; Populate array

mov ecx, arraySize
mov esi, OFFSET array

L1: 
	mov eax, [esi]							; Move array element to eax
	call WriteInt							; Print the array element
	mov edx, OFFSET msg						
	call WriteString						; Print a comma and space
	add esi, TYPE array						; Point to next array item
	loop L1

call CrLf
mov edx, OFFSET msg0
call WriteString							; Print a blank
call CrLf									; Next line
mov edx, OFFSET msg1						; Point to message 1
call WriteString							; Display message 1
call ReadInt								; Take input for j
mov j, eax									; Store value of j
call CrLf									; Next line

mov edx, OFFSET msg2						; Point to message 2
call WriteString							; Display message 2
call ReadInt								; Take input for k
mov k, eax									; Store value of k
call CrLf									; Next line

mov edx, OFFSET msg3						; Point to message 3
call WriteString							; Display message 3
mov eax, 0									; Clear eax
mov ebx, j									; Move j to ebx
mov edx, k									; Move k to edx
mov ecx, arraySize							; Move the length of the array to ecx
mov esi, OFFSET array						; Point to beggining of array
call sumValues								; Call procedure to sum values
call CrLf									; Next line


exit
main ENDP

;************************************************************
initializeRandom PROC USES eax ebx ecx esi
; Receives: EAX, EBX
; Returns: EAX = random number from -1000 to +1000
;************************************************************


	L1: 
		mov eax, 1000			; Upper range
		mov ebx, -1000			; Lower range
		sub eax, ebx
		inc eax					; Make range inclusive
		call RandomRange		; Call library function
		add eax, ebx			; Make range -1000 to 1000 
		mov [esi], eax			; Add random to array
		add esi, TYPE DWORD		; increment esi
		loop L1					; Continue loop

ret
initializeRandom ENDP

;************************************************************
sumValues PROC USES edx ebx edi esi
; sum values in an array with values between j and k 
; Receives: EDX, EBX
; Returns: EAX = sum of elements between j and k
;************************************************************

mov edi, 0						; index = 0

L1:	
	cmp edi, ecx				; while(index < arraySize)
	jnge L2						; Loop L2
	jmp Finish					; Jump to the end if finished

L2: 
	cmp [esi], ebx				; Compare array element to j
	jnge L5						; Jump to L5 if array element less than j
	cmp [esi], edx				; Compare same array element to k
	jnle L5						; Jump to L5 if array element greater than k
	add eax, [esi]				; Add array element to accumulator

L5: 
	inc edi						; Increment index
	add esi, TYPE DWORD
	jmp L1						; Continue L1 loop

Finish:
call WriteInt
ret
sumValues ENDP

END main