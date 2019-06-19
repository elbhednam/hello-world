TITLE {NumberSequence}		(NumberSequence.asm)

;Assignment 3, Question C
;Amanda Bakalarczyk
;2017-10-14

;Program calculates a number sequence described by the formula  
;F(n) = F(n-1) * 2 + Fib(n-4) for n >=5

COMMENT ! 
import java.util.*;

public class C {
	
	static int f1 = 1;
	static int f2 = 2;
	static int f3 = 3;
	static int f4 = 2;
	static int fn = 5;
	static ArrayList<Integer> al = new ArrayList<Integer>();
	
	public static void main(String[] args) {
		
		al.add(1);
		al.add(2);
		al.add(3);
		al.add(2);
		
		
		for (int i = 4; i < 24; i++) {
			al.add((al.get(i - 1) * 2) + al.get(i - 4));
		}
		
		for (int i = 0; i < 20; i++) {
			System.out.print(al.get(i) + ", ");
		}
	}
}!

INCLUDE Irvine32.inc

.data

msg BYTE ", ", 0

f BYTE 20 DUP(?)

.code
main PROC

	mov edx, OFFSET msg				;Ready message
	mov esi, OFFSET f				;Point to beginning of array
	mov ecx, 4						;Set loop counter to 4
	mov eax, 0						;Clear eax

	mov al, 1
	mov [esi], al					;Add 1 to array
	inc esi							;Move to next array index
	mov al, 2
	mov [esi], al					;Add 2 to array
	inc esi							;Move to next array index
	mov al, 3						
	mov [esi], al					;Add 3 to array
	inc esi							;Move to next array index
	mov al, 2
	mov [esi], al					;Add 2 to array
	inc esi							;Move to next array index
	
	mov esi, OFFSET f				;Point to beginning of array

	L1: 
		
		mov al, [esi]				;Move first element of array to al
		call WriteDec				;Display first number in seqence
		call WriteString			;Display ", "
		inc esi						;Increment esi
		loop L1						;Continue L1 for first 4 elements of the sequence

	mov ecx, 16						;Set loop counter to 16 iterations
	mov eax, 0						;Clear eax

	L2:
		
		mov al, [esi - 1]			;Move f(n - 1) to al
		add al, [esi - 1]			;Multiyply f(n - 1) by 2
		add al, [esi - 4]			;Add f(n - 4)
		call WriteDec				;Display result
		call WriteString			;Display ", "
		mov [esi], al				;Story result in esi
		add esi, TYPE f				;Increment esi
		;call DumpRegs
		mov eax, 0					;Clear eax
		loop L2						;Continue L2

	call CrLf						;Next line

	exit
main ENDP

END main