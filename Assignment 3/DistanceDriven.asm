TITLE {DistanceDriven}		(DistanceDriven.asm)

INCLUDE Irvine32.inc

.data

msg1 BYTE "Enter your average speed (km/hour): ", 0
msg2 BYTE "Enter the minimum number of hours you intend to drive: ", 0
msg3 BYTE "Enter the maximum number of hours you intend to drive: ", 0
msg4 BYTE "Hours	Distance Driven", 0
msg5 BYTE "------------------------", 0
msg6 BYTE "              ", 0

speed DWORD ?
min DWORD ?
max DWORD ?
count DWORD ?

.code
main PROC
	
	mov edx, OFFSET msg1		
	call WriteString			;Display message 
	call ReadDec				;Collect unsigned integer
	mov speed, eax				;Store unsigned integer 
	call CrLf

	mov edx, OFFSET msg2		
	call WriteString			;Display message 
	call ReadDec				;Collect unsigned integer
	mov min, eax				;Store unsigned integer 
	call CrLf

	mov edx, OFFSET msg3		
	call WriteString			;Display message 
	call ReadDec				;Collect unsigned integer
	mov max, eax				;Store unsigned integer 
	call CrLf

	mov edx, OFFSET msg4		
	call WriteString			;Display message 
	call CrLf					
	mov edx, OFFSET msg5		
	call WriteString			;Display message 
	call CrLf					
	
	mov ecx, min				;Set loop counter 
	mov ebx, 0					

	L1:
		add ebx, speed			
		loop L1					;Loop through L1

	mov ecx, max				
	sub ecx, min 				
	inc ecx						

	L2:
		mov count, ecx			;Save outer loop counter
		mov eax, min			;Move min value to eax
		call WriteDec			;Display min value
		inc min					;Increment min value
		mov edx, OFFSET msg6	
		call WriteString		;Display message 
		xchg eax, ebx			;Swap contents of eax and ebx
		call WriteDec			;Display distance
		call CrLf				;Next line
		mov ebx, 0				;Clear ebx
		mov ecx, min			;Set inner loop counter
	
	L3:
		add ebx, speed			
		loop L3					;Continue inner loop
		mov ecx, count			;restore outer loop counter
		loop L2					;Continue outer loop


	exit
main ENDP

END main