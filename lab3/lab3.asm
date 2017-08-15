; Assuming user will only enter ' ' 0-9 *+/-
;
;
;
.ORIG x3000
; Your code goes here    
        
;subroutine call!
	JSR ECHO		;
	

HALT
        
STR_ADDR        .FILL x5000             
SPACE           .FILL x0020
NEW_LINE        .FILL x000A
CHAR_RETURN     .FILL x000D

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subroutine: ECHO
; -gets a string of ASCII values input from user, decodes each character and stores
;  them in memory, until newline is entered(newline is stored in memory too).
; specifically, it
;	1. save original R1,R2,R7 value in memory(R1,2 for calculations and R7 for 
;	   return point to original program)
; 	2. gets a single character from user
;	3. prints it out, decodes it, stores it in memory
;	4. check the decoded char to see if input was newline (xD, xFFF3 when decoded)
;	5. if so, load original R1, R2 and R7 and return to program.
;	6. if not, go back to step 2.

ECHO

	ST R1, ECHO_TEMP_R1	; store R1 value into temp space in memory
	ST R2, ECHO_TEMP_R2	; store R2 value into temp space in memory
	ST R7, ECHO_TEMP_R7	; store R7(return point) in memory
	LD R1, STR_ADDR		; R1 = pointer to input string
	
input	GETC			; get a single char input
	OUT			; print out the char
	JSR DECODE		; convert value in R0 to storable format
	STR R0, R1, #0		; R0 -> memory[R1]. R1 is ptr to string.
	ADD R1, R1, #1		; increment string pointer to next slot
	
check_newline
	LD R2, CHAR_RETURN	; R2 <- xD
	ADD R0, R0, R2		; was the decoded character xFFF3?
	BRz reload		; if so, reload orig register values and exit subrt.
	LD R0, SPACE		; if not, print space and
	OUT			;
	BR input		; move onto next character input

reload	LD R1, ECHO_TEMP_R1	; reload R1 with original value
	LD R2, ECHO_TEMP_R2	; reload R2 with original value
	LD R7, ECHO_TEMP_R7	; reload R7 with original value
	RET			;

ECHO_TEMP_R1	.BLKW #1	; temp storage for R1	
ECHO_TEMP_R2	.BLKW #1	; temp storage for R2
ECHO_TEMP_R7	.BLKW #1	; temp storage for R7

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subroutine: DECODE
; input: R0 holds the input
; output: R0 holds numerical value or negation of the ascii value
;   find the numerical value of if input is an operand, 
;   or find the negation of the ascii value if the input is an operator

DECODE

; Your code goes here

; Save values in registers into memory
	ST R1, DECODE_TEMP_REG	; Store R1 into DECODE_TEMP_REG

; Is the content of R0 Operand or Operator?
	AND R1, R1, #0		; R1 will be used for calculations
	LD R1, ZERO		; R1 = "0". note that operands ASCII < decimal ASCII
	NOT R1, R1		; lets try R1 = R0 - '0'
	ADD R1, R1, #1		; R1 = -'0'
	ADD R1, R0, R1		; 
	BRzp OPERAND		; if result is neg, R0 stores an operand
OPERATOR	
	NOT R0, R0		; R0 will store negation of ASCII value
	ADD R0, R0, #1		; R0 = NOT(R0)+1
	BR RELOAD_REGISTER	; reload saved register values
OPERAND	
	LD R1, ZERO		; R0 - '0' will return numberical value, non-ASCII 
	NOT R1, R1		; R1 = -'0'
	ADD R1, R1, #1		;
	ADD R0, R0, R1		; R0 = R0 - '0' = numberical value
RELOAD_REGISTER			; reload the saved register values
	LD R1, DECODE_TEMP_REG	; load the original R1 value
	RET			; done subroutine, return to original program


ZERO		.FILL x0030
DECODE_TEMP_REG	.BLKW #1	; temp storage for R1 for DECODE subroutine.

.END

