;
; The code given to you here implements the histogram calculation that 
; we developed in class.  In programming lab, we will add code that
; prints a number in hexadecimal to the monitor.
;
; Your assignment for this program is to combine these two pieces of 
; code to print the histogram to the monitor.
;
; If you finish your program, 
;    ** commit a working version to your repository  **
;    ** (and make a note of the repository version)! **


	.ORIG	x3000		; starting address is x3000


;
; Count the occurrences of each letter (A to Z) in an ASCII string 
; terminated by a NUL character.  Lower case and upper case should 
; be counted together, and a count also kept of all non-alphabetic 
; characters (not counting the terminal NUL).
;
; The string starts at x4000.
;
; The resulting histogram (which will NOT be initialized in advance) 
; should be stored starting at x3F00, with the non-alphabetic count 
; at x3F00, and the count for each letter in x3F01 (A) through x3F1A (Z).
;
; table of register use in this part of the code
;    R0 holds a pointer to the histogram (x3F00)
;    R1 holds a pointer to the current position in the string
;       and as the loop count during histogram initialization
;    R2 holds the current character being counted
;       and is also used to point to the histogram entry
;    R3 holds the additive inverse of ASCII '@' (xFFC0)
;    R4 holds the difference between ASCII '@' and 'Z' (xFFE6)
;    R5 holds the difference between ASCII '@' and '`' (xFFE0)
;    R6 is used as a temporary register
;

	LD R0,HIST_ADDR      	; point R0 to the start of the histogram
	
	; fill the histogram with zeroes 
	AND R6,R6,#0		; put a zero into R6
	LD R1,NUM_BINS		; initialize loop count to 27
	ADD R2,R0,#0		; copy start of histogram into R2

	; loop to fill histogram starts here
HFLOOP	STR R6,R2,#0		; write a zero into histogram
	ADD R2,R2,#1		; point to next histogram entry
	ADD R1,R1,#-1		; decrement loop count
	BRp HFLOOP		; continue until loop count reaches zero

	; initialize R1, R3, R4, and R5 from memory
	LD R3,NEG_AT		; set R3 to additive inverse of ASCII '@'
	LD R4,AT_MIN_Z		; set R4 to difference between ASCII '@' and 'Z'
	LD R5,AT_MIN_BQ		; set R5 to difference between ASCII '@' and '`'
	LD R1,STR_START		; point R1 to start of string

	; the counting loop starts here
COUNTLOOP
	LDR R2,R1,#0		; read the next character from the string
	BRz PRINT_HIST		; found the end of the string

	ADD R2,R2,R3		; subtract '@' from the character
	BRp AT_LEAST_A		; branch if > '@', i.e., >= 'A'
NON_ALPHA
	LDR R6,R0,#0		; load the non-alpha count
	ADD R6,R6,#1		; add one to it
	STR R6,R0,#0		; store the new non-alpha count
	BRnzp GET_NEXT		; branch to end of conditional structure
AT_LEAST_A
	ADD R6,R2,R4		; compare with 'Z'
	BRp MORE_THAN_Z         ; branch if > 'Z'

; note that we no longer need the current character
; so we can reuse R2 for the pointer to the correct
; histogram entry for incrementing
ALPHA	ADD R2,R2,R0		; point to correct histogram entry
	LDR R6,R2,#0		; load the count
	ADD R6,R6,#1		; add one to it
	STR R6,R2,#0		; store the new count
	BRnzp GET_NEXT		; branch to end of conditional structure

; subtracting as below yields the original character minus '`'
MORE_THAN_Z
	ADD R2,R2,R5		; subtract '`' - '@' from the character
	BRnz NON_ALPHA		; if <= '`', i.e., < 'a', go increment non-alpha
	ADD R6,R2,R4		; compare with 'z'
	BRnz ALPHA		; if <= 'z', go increment alpha count
	BRnzp NON_ALPHA		; otherwise, go increment non-alpha

GET_NEXT
	ADD R1,R1,#1		; point to next character in string
	BRnzp COUNTLOOP		; go to start of counting loop



PRINT_HIST

; you will need to insert your code to print the histogram here

; do not forget to write a brief description of the approach/algorithm
; for your implementation, list registers used in this part of the code,
; and provide sufficient comments

; Algorithm is as follows:
; 1. Initialize registers(R3 stores value in current bin. R4 used for calculations)
; 2. Traverse through each bin in histogram (use R4 as ptr to current bin)
; 3. Print label(@, A, B and so on). Get Label ASCII val through adding an offset to bin addr(x40-x3F00).
; 4. Print value of bin in Hexadecimal(value stored in R3)

INIT
	AND R0, R0, #0		; R0 = value to be printed w/ TRAP x21
	AND R1, R0, #0		; R1 = digit counter
	AND R2, R2, #0		; R2 = bit counter
	LDI R3, HIST_ADDR	; R3 holds value in current bin.
	AND R4, R4, #0		; R4 = used for calculations
	LD R5, MASK		; R5 used for MSB bitmask 
	AND R6, R6, #0		; R6 will contain offset for decimal digits/letters.
	BR BIGLOOP		; start program

NEXT_BIN			; preparation for getting next bin. CHECK HERE FOR ERRORS FIRST
	ADD R0, R0, x0A		; R0 <- newline ASCII
	OUT			; print newline
	AND R0, R0, #0		; reset R0
	AND R1, R1, #0		; reset digit counter
	LD R4, BIN_COUNTER	; load bin counter
	ADD R4, R4, #1		; increment bin counter
	ST R4, BIN_COUNTER	; store the incremented bin counter.
	LD R3, HIST_ADDR	; load ptr to first bin
	ADD R3, R3, R4		; Add Bin counter to the bin ptr, to point to current bin val
	LDR R3, R3, #0		; R3 <- mem[R3]
	

BIGLOOP
	LD R4, BIN_COUNTER	; load bin counter to R4
	ADD R4, R4, #-16	; have 27 bins been printed?
	ADD R4, R4, #-11	;
	BRz DONE		; since 27 letters have been printed, halt program
 
PRINT_LABEL			; printing each label by adding #letters printed and '@'
	LD R0, BIN_OFFSET	; R0 <- '@'
	LD R4, BIN_COUNTER	; R4 <- #lettersPrinted(aka bincounter)
	ADD R0, R0, R4		; R0 <- #lettersPrinted + '@'
	OUT			; print label
	LD R0, SPACE		;
	OUT			; print space
	AND R0, R0, #0		; reset R0 to be used later

PRINT_BIN
	AND R4, R4, #0		; R4 used for calculations	

				; Have we printed 4 Digits?
	ADD R4, R1, #-4		; R4 <- #DigitsPrinted(digitcount) - 4
	BRz NEXT_BIN		; Yes; move onto next bin.

SEPARATE_DIGIT			; get the leftmost four bits from R3 into R0 through left shift
				;
GETBIT	AND R4, R4, #0		; R4 used for calculations	
	ADD R4, R2, #-4		; check if 4 bits have been shifted
	BRz CONVERT		; if so, move onto convert to ascii 
	ADD R0, R0, R0		; LShift R0 once
	AND R4, R3, R5		; is the MSB 0 or 1?
	BRzp NEXTBIT 		; since 0, move onto next bit
	ADD R0, R0, #1		; if not, add 1 if the MSB was 1
NEXTBIT	ADD R2, R2, #1		; increment bit counter
	ADD R3, R3, R3		; shift data to be printed
	BR GETBIT		; get the next bit

; convert binary into print-ready ASCII form first, then
; print the code
	
CONVERT	AND R4, R4, #0		; R4 used for calculations
	ADD R4, R0, #-9		; is R4 greater than 9? (BRp=letter, BRnz=digits)
	BRp LETTRS		; then skip to lettrs offset
DIGITS	LD R6, DIGIT_OFFSET	; load R6 w/ digit offset
	ADD R0, R0, R6		; add offset for numbers
	BR OUTPUT		; now get to actual printing
LETTRS	LD R6, LETTR_OFFSET	; load R6 w/ letter offset
	ADD R6, R6, #-10	; subtract 10 to account for decimal digits 0-9
	ADD R0, R0, R6		; add offset for letters.
OUTPUT	OUT			; print R0(readied bin value)
	AND R0, R0, #0		; reset R0
	AND R2, R2, #0		; reset bit counter
	ADD R1, R1, #1		; increment digit counter

	BR PRINT_BIN		; go back to beginning

DONE	HALT			; done



; the data needed by the program
NUM_BINS	.FILL #27	; 27 loop iterations
NEG_AT		.FILL xFFC0	; the additive inverse of ASCII '@'
AT_MIN_Z	.FILL xFFE6	; the difference between ASCII '@' and 'Z'
AT_MIN_BQ	.FILL xFFE0	; the difference between ASCII '@' and '`'
HIST_ADDR	.FILL x3F00     ; histogram starting address
STR_START	.FILL x4000	; string starting address
; added data for MP1
MASK 		.FILL x8000	; 1000 0000 0000 0000
DIGIT_OFFSET 	.FILL x0030	; offset for decimal digits
LETTR_OFFSET 	.FILL x0041	; offset for letters
BIN_OFFSET	.FILL x0040	; offset for printing bin labels
SPACE		.FILL x0020	; printed after label
BIN_COUNTER	.FILL x0000	; used as bin counter, # of bins printed so far.

; for testing, you can use the lines below to include the string in this
; program...
; STR_START	.FILL STRING	; string starting address
; STRING		.STRINGZ "This is a test of the counting frequency code.  AbCd...WxYz."



	; the directive below tells the assembler that the program is done
	; (so do not write any code below it!)

	.END
