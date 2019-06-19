TITLE {A}	(A.asm)

;Program reads data from file traverses indexes and locates characters in their correct sequence to form a message
;Amanda Bakalarczyk
;Assignment 4
;Problem A
;2017-10-27

INCLUDE irvine32.inc

.data

file BYTE "index2.dat",0
lett	BYTE 'Z', 'X', 'A', 'P', 'Q', 'S', 'I', 'U', 'M', 'K', 'H', 'R', 'L', 
			 'J', 'C', 'E', 'G', 'Y', 'N', 'O', 'V', 'D', 'F', 'B', 'W', 'T'
ind BYTE 0, 17, 23, 4, 11, 25, 13, 20, 18, 12, 6, 5, 8, 9, 21, 22, 10, 0, 
			 19, 3, 24, 15, 16, 14, 1, 7, 2

letters BYTE 26 DUP(?)
index BYTE 27 DUP(?)
buffer BYTE 15 DUP(0) 
fileName DWORD ?
start BYTE 0

msg1 BYTE "What is the name of the data file? ", 0
msg2 BYTE "Secret message: ", 0

.code
main PROC

; Mike wrote this part

mov edx, OFFSET file
call CreateOutputFile
push eax

mov ecx, SIZEOF lett
add ecx, SIZEOF ind
mov edx, OFFSET lett
call WriteToFile

pop eax
call CloseFile

; This part is all mine

mov edx, OFFSET msg1				; Point to message 1
call WriteString					; Display message 1
call CrLf							; Next line

mov edx, OFFSET buffer				; Point to the buffer
mov ecx, LENGTHOF buffer			; Specify max characters
call ReadString						; Input the string
call OpenInputFile					; Open file
mov fileName, eax					; Store file name

mov edx, OFFSET letters				; Point to letters buffer
mov ecx, LENGTHOF letters			; 26 bytes to read in ecx
;add ecx, LENGTHOF index				; 27 bytes to read in ecx

call ReadFromFile					; Read from file to letters buffer
mov eax, filename
mov edx, OFFSET index				; Point to index buffer
mov ecx, LENGTHOF index				; 27 bytes to read in ecx
call ReadFromFile					; Read from file to index buffer

mov eax, fileName					; Pass file handle to eax
call CloseFile						; Close the file

mov edx, OFFSET msg2				; Point to message 2
call WriteString					; Display message 2
call CrLf

;mov edx, offset letters
;call WriteString
;call CrLf

;mov ecx, 27
;mov esi, offset index
;mov eax, 0
;l2:
;mov al, [esi]
;call WriteDec
;mov al, ' '
;call WriteChar
;inc esi
;loop l2
;call crlf

mov eax, 0							; Clear eax
mov ebx, 0
mov ecx, SIZEOF letters				; Set loop counter to length of letters array
mov esi, OFFSET index				; Point esi to index array
mov bl, index[26]					; Move the element at last index to bl = [index + 26] 
mov al,bl
call WriteDec
call Crlf
;mov start, bl						; Store al as starting index
mov edi, OFFSET letters				; Point esi to letters array


L1:
	;mov al, [edi + ebx]				; Move the element at specified index to bl - letters[bl]
	mov al, letters[ebx]				; Move the element at specified index to bl - letters[bl]
	call WriteChar					; Display element at specified index
	;mov bl, [esi + ebx]				; Get new index as index[bl]
	mov bl, index[ebx]				; Get new index as index[bl]
	loop L1							; Continue loop
	
	
exit
main ENDP

END main