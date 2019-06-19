TITLE {Icosahedron}	(Icosahedron.asm)

; Finds and reports volume and area of a regular icosahedron
; COSC 2046
; Amanda Bakalarczyk
; Assignment 7, Q1
; 2017-11-20

INCLUDE irvine32.inc

.data

msg1 BYTE "Supply the length of the edge of an icosahedron: ", 0
msg2 BYTE "Length must not be negative ", 0
msg3 BYTE "The area of the icosahedron is ", 0
msg4 BYTE "The volume of the icosahedron is ", 0

edge REAL4 ?
area REAL4 ?
volume REAL4 ?

temp1 REAL4 ?
temp2 REAL4 ?

int3 DWORD 3
int5 DWORD 5
int12 DWORD 12

.code
main PROC

;Area = 5 sqrt3 * e^2
;Volume = (5 (3 + sqrt5) / 12) * e^3

finit											; Initialize the FPU

fild int3										; ST(0) = 3
fsqrt											; ST(0) = sqrt(3)
fimul int5										; ST(0) = 5 * sqrt(3)
fstp temp1										; temp1 = 5 * sqrt3

fild int5										; ST(0) = 5
fsqrt											; ST(0) = sqrt(5)
fiadd int3										; ST(0) = 3 + sqrt(5)
fimul int5										; ST(0) = 5 (3 + sqrt(5))
fidiv int12										; ST(0) = 5 (3 + sqrt(5)) / 12
fstp temp2										; temp2 = 5 (3 + sqrt(5)) / 12

L1:
mov edx, OFFSET msg1							; Point to message 1
call WriteString								; Display message 1
call ReadFloat									; Read in a floating point value
call CrLf										; Next line

fldz											; ST(0) = 0
fcomp											; Compare zero to e
fnstsw ax										; Move the FPU status word into AX.
sahf											; Copy AH into the EFLAGS register
jz L3											; 					
jb L2
mov edx, OFFSET msg2							; Point to message 2
call WriteString								; Display message 2
call CrLf										; Next line
mov al, ' '
call WriteChar
call CrLf
jmp L1

L2:
fstp edge										; Store ST(0) in edge variable
fld edge										; ST(0) = edge
fmul edge										; ST(0) = edge^2
fld temp1										; ST(0) = 5 * sqrt(3), ST(1) = edge^2
fmul											; ST(0) = 5 * sqrt(3) * edge^2

mov edx, OFFSET msg3							; Point to message 3
call WriteString								; Display message 3
call WriteFloat									; Display area
fstp area										; Store result in area variable
call CrLf										; Next line

fld edge										; ST(0) = edge
fmul edge										; ST(0) = edge^2
fmul edge										; ST(0) = edge^3
fld temp2										; ST(0) = 5/12 (3 + sqrt5), ST(1) = edge
fmul											; ST(0) = 5/12 (3 + sqrt5) * edge^3

mov edx, OFFSET msg4							; Point to message 4
call WriteString								; Display message 4
call WriteFloat									; Display area
fstp volume										; Store result in area variable
call CrLf										; Next line
mov al, ' '
call WriteChar
call CrLf
jmp L1											; Repeat until 0 entered

L3:
exit
main ENDP
END main