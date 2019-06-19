TITLE {StringRemove}	(StringRemove.asm)

; Removes n characters from a string.
; Amanda Bakalarczyk
; COSC 2406
; Assignment 8, Q1
; 2017-11-26

INCLUDE irvine32.inc

.data

msg1 BYTE "Enter the target string: ", 0
msg2 BYTE "Enter the index of the first character to remove: ", 0
msg3 BYTE "Enter the number of characters to remove: ", 0
target BYTE 21 DUP(0) 
strLen DWORD ?
index DWORD ?
number DWORD ?

Str_Remove PROTO,
targetStr : PTR BYTE,
n : DWORD

.code
main PROC

mov edx, OFFSET msg1								; Point to message 1
call WriteString									; Display message 1
mov edx, OFFSET target								; Point to the target string buffer
mov ecx, SIZEOF target								; Specify max characters
call ReadString										; Input the string
mov strLen,	eax										; Store length of input string							
											
L1:
call CrLF											; Next line
mov edx, OFFSET msg2								; Point to message 2
call WriteString									; Display message 2
call ReadDec										; Take input for string index											
cmp eax, strLen										; Is the index out of range for the string?
ja L1												; Yes: Ask again
cmp eax, 0											; Is the index negative?
jb L1												; Yes: Ask again
mov index, eax										; Store index
call CrLf											; Next line

mov edx, OFFSET msg3								; Point to message 3
call WriteString									; Display message 3
call ReadDec										; Take input for number of characters to remove
mov number, eax										; Store number
add eax, index										; Starting index + the characters to remove
cmp eax, strLen										; > string length ?
jbe L2												; Yes: call the procedure
dec number											; No: Reduce the number of characters to remove

L2:
mov eax, index
INVOKE Str_remove, ADDR [target + eax], number

mov edx, OFFSET target
call WriteString
call CrLf

exit
main ENDP

;*************************************************
Str_remove PROC,
targetStr : PTR BYTE,
n : DWORD
; Receives: Addresses of target string, number of characters to remove
; Returnes: substring in EDI
;*************************************************

mov esi, targetStr
add esi, n

mov eax, 0						

L1:
cmp BYTE PTR [esi], 0								; End of string?
je L2												; Yes: Go to L2
inc esi												; Move to next element
inc eax												; Increment accumulator
jmp L1												; Continue

L2:
mov edi, targetStr									; edi = string offset + index					
mov esi, targetStr
add esi, n											; esi = edi + number of characters to remove
mov ecx, eax										; ecx = length of esi
inc ecx												; add one for null terminator
cld													; clear direction flag
rep movsb

ret
Str_remove ENDP
END main