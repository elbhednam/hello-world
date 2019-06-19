TITLE {StringConcatenation}	(StringConcatenation.asm)

; Concatenates a source string to the end of a target string.
; Amanda Bakalarczyk
; COSC 2406
; Assignment 8, Q1
; 2017-11-26

INCLUDE irvine32.inc

.data

msg1 BYTE "Enter the target string: ", 0
msg2 BYTE "Enter the source string: ", 0
destStr BYTE 21 DUP(0) 
sourceStr BYTE 21 DUP(0) 

Str_concat PROTO,
target : PTR BYTE,
source : PTR BYTE 

.code
main PROC

mov edx, OFFSET msg1								; Point to message 1
call WriteString									; Display message 1
mov edx, OFFSET destStr								; Point to the destination string buffer
mov ecx, SIZEOF destStr								; Specify max characters
call ReadString										; Input the string
call CrLF											; Next line

mov edx, OFFSET msg2								; Point to message 2
call WriteString									; Display message 2
mov edx, OFFSET sourceStr							; Point to the source string buffer
mov ecx, SIZEOF sourceStr							; Specify max characters
call ReadString										; Input the string
													; **EAX contains length of source string**
call CrLF											; Next line

INVOKE Str_concat, ADDR destStr, ADDR sourceStr		; Call procedure

mov edx, OFFSET destStr								; Point to destination string (now result)
call WriteString									; Show result
call CrLf

exit
main ENDP

;*************************************************
Str_concat PROC,
target : PTR BYTE,
source : PTR BYTE 
; Receives: Addresses of source and target strings
; Returnes: Concatenated string in EDI
;*************************************************

mov ecx, eax										; Move length of source string to ecx
inc ecx												; Add 1 for null byte

mov edi, target
mov esi, source

L1: 
cmp BYTE PTR [edi], 0								; End of target string?
je L2												; Yes: go to L2
inc edi												; No: increment edi until the end is reached
jmp L1

L2:
cld													; Direction = forward
rep movsb											; Copy the string

ret
Str_concat ENDP

END main