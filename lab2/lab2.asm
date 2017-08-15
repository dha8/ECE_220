; Programming Lab 2 
; assignment: develop a code to print a value stored in a register 
;             as a hexadecimal number to the monitor
; algorithm: turnin each group of four bits into a digit
;            calculate the corresponding ASCII character;
;            print the character to the monitor
;
;	by Dawith Ha, dha8
;	

; Initializations
	.ORIG x3000
	AND R0, R0, #0		; R0 = value to be printed w/ TRAP x21
	AND R1, R0, #0		; R1 = digit counter
	AND R2, R2, #0		; R2 = bit counter
	LD R5, MASK		; R5 used for MSB bitmask
	AND R6, R6, #0		; R6 will contain offset for decimal digits/letters

; Algorithm begins here
BEGIN	AND R4, R4, #0		; R4 used for calculations	

; Have we printed 4 Digits?
	ADD R4, R1, #-4		;
	BRz DONE		; 

; get the leftmost four bits from R3 into R0 through left shift
GETBIT	AND R4, R4, #0		; R4 used for calculations
	ADD R4, R2, #-4		; check if 4 bits have been shifted
	BRz PRINT		; if so, print it 
	ADD R0, R0, R0		; LShift R0 once
	AND R4, R3, R5		; is the MSB 0 or 1?
	BRzp NEXTBIT 		; since 0, move onto next bit
	ADD R0, R0, #1		; if not, add 1 if the MSB was 1
NEXTBIT	ADD R2, R2, #1		; increment bit counter
	ADD R3, R3, R3		; shift data to be printed
	BR GETBIT		; get the next bit
	

; convert binary into print-ready ASCII form first, then
; print the code
	
PRINT	AND R4, R4, #0		; R4 used for calculations
	ADD R4, R0, #-9		; is R4 greater than 9? (BRp=letter, BRnz=digits)
	BRp LETTRS		; then skip to lettrs offset
DIGITS	LD R6, DIGIT_OFFSET	; load R6 w/ digit offset
	ADD R0, R0, R6		; add offset for numbers
	BR OUTPUT		; now get to actual printing
LETTRS	LD R6, LETTR_OFFSET	; load R6 w/ letter offset
	ADD R6, R6, #-10	; why though?
	ADD R0, R0, R6		; add offset for letters.
OUTPUT	TRAP x21		; print R0
	AND R0, R0, #0		; reset R0
	AND R2, R2, #0		; reset bit counter
	ADD R1, R1, #1		; increment digit counter

	BR BEGIN		; go back to beginnin'

; stop the computer
	DONE TRAP x25	; done program

; program data section starts here
	MASK .FILL x8000 ; 1000 0000 0000 0000
	DIGIT_OFFSET .FILL x0030 ; offset for decimal digits
	LETTR_OFFSET .FILL x0041 ; offset for letters
	.END

