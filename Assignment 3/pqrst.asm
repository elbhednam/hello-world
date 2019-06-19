TITLE {pqrst}		(pqrst.asm)

;Stores signed and unsigned integers in double word variables, P, Q, R, S, & T. 
;Five values used to solve and report the results of equations using EBX and EAX registers

;Amanda Bakalarczyk
;Assignment 3, Question A
;2017-10-11

COMMENT !
import java.util.*;

public class A {
	
	static int p;
	static int q;
	static int r;
	static int s;
	static int t;
	static int result1;
	static int result2;
	static int result3;
	static Scanner input = new Scanner(System.in);

	public static void main(String[] args) {
		
		
		System.out.print("Enter an unsigned value for P: ");
		p = input.nextInt();
		System.out.print("Enter a signed value for Q: ");
		q = input.nextInt();
		System.out.print("Enter an unsigned value for R: ");
		r = input.nextInt();
		System.out.print("Enter a signed value for S: ");
		s = input.nextInt();
		System.out.print("Enter an unsigned value for T: ");
		t = input.nextInt();
		
		result1 = (p + r) - (q + s) + t;
		result2 = t + (p - r) - (s + q);
		result3 = (s + q) + (t - p) - r;
		
		System.out.println();
		
		System.out.println("(P + R) - (Q + S) + T = " + result1);
		System.out.println("T + (P - R) - (S + Q) = " + result2);
		System.out.println("(S + Q) + (T - P) - R = " + result3);
	}
} !

INCLUDE Irvine32.inc

.data
msg1 BYTE "Enter a unsigned value for P: ", 0
msg2 BYTE "Enter a signed value for Q: ", 0
msg3 BYTE "Enter a unsigned value for R: ", 0
msg4 BYTE "Enter a signed value for S: ", 0
msg5 BYTE "Enter a unsigned value for T: ", 0
msg6 BYTE "(P + R) - (Q + S) + T = ", 0
msg7 BYTE "T + (P - R) - (S + Q) = ", 0
msg8 BYTE "(S + Q) + (T - P) - R = ", 0

P DWORD ?
Q SDWORD ?
R DWORD ?
S SDWORD ?
T DWORD ?

.code
main PROC
	
	mov edx, OFFSET msg1		;Ready message 1
	call WriteString			;Ask for P value
	call ReadDec				;Collect unsigned integer 
	mov P, eax					;Store unsigned integer value in P
	call CrLf	
	
	mov edx, OFFSET msg2		;Ready message 2
	call WriteString			;Ask for Q value
	call ReadInt				;Collect signed integer value 
	mov Q, eax					;Store signed integer value in Q
	call CrLf

	mov edx, OFFSET msg3		;Ready message 3
	call WriteString			;Ask for R value
	call ReadDec				;Collect unsigned integer value 
	mov R, eax					;Store unsigned integer value in R
	call CrLf

	mov edx, OFFSET msg4		;Ready message 4
	call WriteString			;Ask for S value
	call ReadInt				;Collect signed integer value
	mov S, eax					;Store signed integer value in S
	call CrLf

	mov edx, OFFSET msg5		;Ready message 5
	call WriteString			;Ask for T value
	call ReadDec				;Collect unsigned integer value
	mov T, eax					;Store unsigned integer value in T
	call CrLf

	mov eax, P					;Move P to eax
	add eax, R					;Add R to eax				(P + R)
	mov ebx, Q					;Move Q to ebx
	add ebx, S					;Add S to ebx				(Q + S)
	sub eax, ebx				;Subtract ebx from eax		(P + R) - (Q + S)
	add eax, T					;Add T to eax				(P + R) - (Q + S) + T
	mov edx, OFFSET msg6		;Ready message 6
	call WriteString			;Display message 6
	call WriteInt				;Print result of first equation
	call CrLf

	mov eax, P					;Move P to eax
	sub eax, R					;Subtract R from eax		(P - R)
	add eax, T					;Add T to eax				T + (P - R)
	mov ebx, S					;Move S to ebx
	add ebx, Q					;Add Q to ebx				(S + Q)
	sub eax, ebx				;Subtract ebx from eax		T + (P - R) - (S + Q)
	mov edx, OFFSET msg7		;Ready message 7
	call WriteString			;Display message 7
	call WriteInt				;Print result of second equation
	call CrLf

	mov eax, S					;Move S to eax
	add eax, Q					;Add Q to eax				(S + Q)
	mov ebx, T					;Move T to ebx
	sub ebx, P					;Subtract P from ebx		(T - P)
	add eax, ebx				;Add ebx to eax				(S + Q) + (T - P)
	sub eax, R					;Subtract R from eax		(S + Q) + (T - P) - R
	mov edx, OFFSET msg8		;Ready message 8
	call WriteString			;Display message 8
	call WriteInt				;Print result of third equation
	call CrLf

	exit
main ENDP

END main