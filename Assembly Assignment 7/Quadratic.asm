TITLE {Quadratic}	(Quadratic.asm)

; Calculates and displays the real roots of a polynomial using the quadratic formula.
; Amanda Bakalarczyk
; Assignment 7, Q2
; 2017-11-20

INCLUDE irvine32.inc

.data

msg1 BYTE "Give the value for coefficient a: ", 0
msg2 BYTE "Give the value for coefficient b: ", 0 
msg3 BYTE "Give the value for coefficient c: ", 0
msg4 BYTE "The equation has two real roots at x = ", 0
msg5 BYTE " and x = ", 0
msg6 BYTE "The equation has one root at x = ", 0
msg7 BYTE "The equation has only imaginary roots"

_a REAL4 ?
_b REAL4 ?
_c REAL4 ?
root0 REAL4 ?
root1 REAL4 ?
discriminant REAL4 ?
temp1 REAL4 ?
temp2 REAL4 ?
temp3 REAL4 ?

int4 DWORD 4
int2 DWORD 2

.code
main PROC

;¸.•*¨¨*•.¸¸¸.User Input.¸¸¸.•*¨¨*•.¸¸¸.•*¨¨*•.¸¸¸.•*

L1:

mov edx, OFFSET msg1							; Point to message 1
call WriteString								; Display message 1
call ReadFloat									; Read value for a
fldz											; ST(0) = 0
fcomip ST(0), ST(1)								; Compare 0 to a
jz L5											; Exit if zero

fstp _a											; Store value in a
call CrLf										; Next line
mov al, ' '
call WriteChar
call CrLf

mov edx, OFFSET msg2							; Point to message 2
call WriteString								; Display message 2
call ReadFloat									; Read value for b
fstp _b											; Store value in b
call CrLf										; Next line
mov al, ' '
call WriteChar
call CrLf

mov edx, OFFSET msg3							; Point to message 3
call WriteString								; Display message 3
call ReadFloat									; Read value for c
fstp _c											; Store value in c
call CrLf										; Next line
mov al, ' '
call WriteChar
call CrLf

;¸.•*¨¨*•.¸¸¸.Discriminant.¸¸¸.•*¨¨*•.¸¸¸.•*¨¨*•.¸¸¸.•*¨¨*•.¸¸¸.•*

fild int4										; ST(0) = 4
fmul _a											; ST(0) = 4 * a
fmul _c											; ST(0) = 4 * a * c
fld _b											; ST(0) = b, ST(1) = 4 * a * c
fmul _b											; multiply to to obtain b^2
fsubr											; ST(0) = b^2 - 4ac
fldz											; ST(0) = 0
fcomip ST(0), ST(1)								; Compare 0 to the discriminant
jb L2											; result 1: discriminant > 0, branch to L2
jz L3											; result 2: discriminant = 0, branch to L3
ja L4											; result 3: discriminant < 0, branch to L4


;.•*¨¨*•.¸¸¸.When b^2 - 4ac > 0, two real roots.¸¸¸.•*¨¨*•.¸¸¸.•*¨¨*•.¸¸¸.•* 

L2:

fstp discriminant								; Store result as discriminant
fld _a											; ST(0) = a
fimul int2										; ST(0) = 2a
fstp temp1										; Store 2a

fld discriminant								; ST(0) = b^2 - 4ac
fsqrt											; ST(0) = sqrt(b^2 - 4ac)
fld _b											; ST(0) = b, ST(1) = sqrt(b^2 - 4ac)
fchs											; ST(0) = -b
fadd											; ST(0) = -b + sqrt(discriminant) 
fdiv temp1										; ST(0) = -b + sqrt(b^2 - 4ac) / (2 * a)
mov edx, OFFSET msg4							; Point to message 4
call WriteString								; Display message 4
call WriteFloat									; Display root
fstp root0										; Store result as root0

fld discriminant								; ST(0) = b^2 - 4ac
fsqrt											; ST(0) = sqrt(b^2 - 4ac)
fld _b											; ST(0) = b, ST(1) = sqrt(b^2 - 4ac)
fchs											; ST(0) = -b
fsubr											; ST(0) = -b - sqrt(discriminant) 
fdiv temp1										; ST(0) = -b - sqrt(b^2 - 4ac) / (2 * a)
mov edx, OFFSET msg5							; Point to message 5
call WriteString								; Display message 5
call WriteFloat									; Display root
fstp root1										; Store result as root1
call CrLf
mov al, ' '
call WriteChar
call CrLf

Jmp L1											; Return to L1

;.•*¨¨*•.¸¸¸.When b^2 - 4ac = 0, x = -b/2a.¸¸¸.•*¨¨*•.¸¸¸.•*¨¨*•.¸¸¸.•* 

L3:

fstp discriminant								; Store result as discriminant
fld _a											; ST(0) = a
fimul int2										; ST(0) = 2a
fstp temp1										; Store 2a

fld _b											; ST(0) = b
fchs											; ST(0) = -b
fdiv temp1										; ST(0) = -b / 2a

mov edx, OFFSET msg6							; Point to message 6
call WriteString								; Display message 6
call WriteFloat									; Display root
fstp root0										; Store as root0
call CrLf
mov al, ' '
call WriteChar
call CrLf

jmp L1											; Return to L1

;.•*¨¨*•.¸¸¸.When b^2 - 4ac < 0, no real roots.¸¸¸.•*¨¨*•.¸¸¸.•*¨¨*•.¸¸¸.•* 

L4:

mov edx, OFFSET msg7							; Point to message 7
call WriteString								; Display message 7
call CrLf
mov al, ' '
call WriteChar
call CrLf

jmp L1											; Return to L1

L5:

mov al, ' '
call WriteChar
call CrLf

exit
main ENDP
END main