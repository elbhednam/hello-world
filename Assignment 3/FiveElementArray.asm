TITLE {FiveElementArray}		(FiveElementArray.asm)

;Assignment 3, Question D
;Amanda Bakalarczyk
;2017-10-13

;Display the items as signed integer values, hex values

COMMENT !

import java.util.*;

public class D {
	
	static byte[] array = new byte[5];
	static int total;
	static Scanner input = new Scanner(System.in);

	public static void main(String[] args) {
		
		System.out.print("Enter the array values: ");
		for (int i = 0; i < array.length; i++) {
			array[i] = input.nextByte();
			total += array[i];
		}
		
		for (int i = 0; i < array.length; i++) {
			System.out.printf("%d%s", array[i], ", ");
		}
		
		System.out.println();
	
		for (int i = 0; i < array.length; i++) {
			System.out.printf("%02x%s", array[i], ", ");
		}
		
		System.out.println();
		System.out.println("Total: " + total);
	}

}!


INCLUDE Irvine32.inc

.data

arrayB BYTE 5 DUP(?)

msg1 BYTE "Enter 5 array elements: ", 0
msg2 BYTE ", ", 0
msg3 BYTE "The sum of all array elements is: ", 0

.code
main PROC

	mov edx, OFFSET msg1		;Ready message 1
	call WriteString			;Display message 1
	call CrLf					;Next line

	mov ecx, LENGTHOF arrayB	;Set loop counter to length of arrayB
	mov edi, OFFSET arrayB		;Point to beginning of arrayB
	mov eax, 0					;Clear eax

	L1:
		call ReadInt			;Read value
		mov [edi], al			;Store value in edi (arrayB)
		add edi, TYPE arrayB	;Move to next array position
		loop L1					;Continue L1

	mov esi, OFFSET arrayB		;Point to beginning of arrayB
	mov ecx, LENGTHOF arrayB	;Set loop counter to length of arrayB
	mov edx, OFFSET msg2		;Ready message 2
	mov eax, 0					;Clear eax

	L2:
		mov al, [esi]			;Pass integer in al register
		call WriteInt			;Display array element as signed integer
		call WriteString		;Display message 2
		add esi, TYPE arrayB	;Point to next array element
		loop L2					;Continue L2

	call CrLf					;Next line

	mov esi, OFFSET arrayB		;Point to beginning of arrayB
	mov ecx, LENGTHOF arrayB	;Set loop counter to the length of arrayB
	mov edx, OFFSET msg2		;Ready message 2
	mov eax, 0					;Clear eax

	L3:
		mov al, [esi]			;Pass integer in al register
		mov ebx, TYPE arrayB	;Set display format to the type of arrayB
		call WriteHexB			;Display array element as hexadecimal
		call WriteString		;Display message 2
		add esi, TYPE arrayB	;Point to next array element
		loop L3					;Continue L3

	call CrLf					;Next line

	mov esi, OFFSET arrayB		;Point to beginning of arrayB
	mov ecx, LENGTHOF arrayB	;Set loop counter to the length of arrayB
	mov edx, OFFSET msg3		;Ready message 3
	mov eax, 0					;Clear eax

	L4:
		add al, [esi]			;add array element to al
		add esi, TYPE arrayB	;Point to next array element
		loop L4					;Continue L4

	call WriteString			;Display message 3
	call WriteInt				;Display sum as signed integer
	call CrLf					;Next line

	exit
main ENDP

END main