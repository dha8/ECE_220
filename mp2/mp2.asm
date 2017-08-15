; Assuming user will only enter ' ' 0-9 *+/-
;
;
;
.ORIG x3000

; your main program should be just a few calls to subroutines, e.g.,

  LD R1, STR_ADDR

  JSR INPUT
  JSR EVALUATE
  JSR PRINT

HALT


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; get input from the keyboard and store it in memory per MP2 specifications
; input: R1 - starting address of the memory to store the expression string
; output: input from the keyboard stored in memory starting from the address passed in R1
INPUT

; defined as "ECHO" in lab3
	ST R1, ECHO_TEMP_R1	; store R1 value into temp space in memory
	ST R2, ECHO_TEMP_R2	; store R2 value into temp space in memory
	ST R3, ECHO_TEMP_R3	; Space checker. if space, ignore
	ST R7, ECHO_TEMP_R7	; store R7(return point) in memory
	LD R1, STR_ADDR		; R1 = pointer to input string	

e_input	LD R3, SPACE		;
	GETC			; get a single char input
	OUT			; print out the char
	
	JSR DECODE		; convert value in R0 to storable format
	ADD R3, R3, R0		; is the input space? if so skip to next input
	BRz e_input		;
	STR R0, R1, #0		; R0 -> memory[R1]. R1 is ptr to string.
	ADD R1, R1, #1		; increment string pointer to next slot
	
check_newline
	LD R2, CHAR_RETURN	; R2 <- xD
	ADD R0, R0, R2		; was the decoded character xFFF3?
	BRz reload		; if so, reload orig register values and exit subrt.
	LD R2, NEW_LINE		; R2 <- xA
	ADD R0, R0, R2		; was newline entered?
	BRz reload		; if so, reload orig register values and exit subrt.
	BR e_input		; move onto next character input

reload	LD R1, ECHO_TEMP_R1	; reload R1 with original value
	LD R2, ECHO_TEMP_R2	; reload R2 with original value
	LD R3, ECHO_TEMP_R3	; reload R3 with original value
	LD R7, ECHO_TEMP_R7	; reload R7 with original value
	RET			;

ECHO_TEMP_R1	.BLKW #1	; temp storage for R1	
ECHO_TEMP_R2	.BLKW #1	; temp storage for R2
ECHO_TEMP_R3	.BLKW #1	; temp storage for R3
ECHO_TEMP_R7	.BLKW #1	; temp storage for R7
STR_ADDR        .FILL x5000             
SPACE           .FILL x0020
NEW_LINE        .FILL x000A
CHAR_RETURN     .FILL x000D


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; find the real value of operand, or keep the 2's complement ASCII value if operator
; input: R0 holds the input
; output: R0
DECODE

; add your code from Lab 3 here
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Your code from Lab 4 that prints value stored in register R0 in decimal format
; input: R0 - holds the input
; output: signed decimal value printed on the display
PRINT

; add your code from Lab 4 here
	ST R3, PRINT_SaveR3	; save orig values
	ST R4, PRINT_SaveR4	; R3, R4 will be used for calculations
	ST R7, PRINT_SaveR7	; save in case of subroutine within subroutines

	ADD R0, R0, #0		; step 0: is input neg/pos?
	BRzp StepONE		; if pos, to step 1
	AND R4, R4, #0		; if NEG, PRINT_isNEG <- xFFFF indicating input
	NOT R4, R4		;  is negative indeed.
	ST R4, PRINT_isNEG	; 
	NOT R0, R0		; take abs. val of input
	ADD R0, R0, #1		;

StepONE	ADD R3, R0, #0		; R3 <- R0
	AND R4, R4, #0		; R4 <- #10
	ADD R4, R4, #10		;
	JSR DIVIDE		; step 1: R0/10. R0<-quotient,
	AND R3, R3, #0		; clear R3 before using it(orig value no longer needed)
	ADD R3, R3, R0		; temporarily move R0 to R3 for 'push'
	AND R0, R0, #0		;
	ADD R0, R0, R1		; R0 now holds remainder
	JSR PUSH			; push remainder onto stack
	AND R0, R0, #0		;
	ADD R0, R0, R3		; R0 holds quotient. step 1 complete
	
	BRnp StepONE		; step 2: if R0 != 0, go to step 1

	LD R3, PRINT_isNEG	; step 3a: is input was neg, print neg sign
	BRzp Step3b		; if input was pos, move to step 3b
	LD R0, MINUS_SIGN	;
	OUT			;
	
Step3b	JSR POP			;
	ADD R5, R5, #0		; was POP successfully carried out?(R5=1 indicates no)
	BRp PRINT_RELOAD	; if stack underflow(empty), done printing
	LD R3, ZERO		;
	ADD R0, R0, R3		; if pop was success, add ASCII offset and
	OUT			; print em out
	BR Step3b		; to the next digit fellas

PRINT_RELOAD
	LD R3, PRINT_SaveR3	;	
	LD R4, PRINT_SaveR4	;	
	LD R7, PRINT_SaveR7	;	
	RET			; exit subroutine

PRINT_SaveR3	.BLKW #1	;
PRINT_SaveR4	.BLKW #1	;
PRINT_SaveR7	.BLKW #1	;
PRINT_isNEG	.BLKW #1	; xFFFF indicates the input is neg
MINUS_SIGN	.FILL x2D	;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input: R1 - start address of the expression string
; output: R0 - the numerical value of the end result
; algorithm:
;	1. read 1 value. is it newline(xFFF6 or xFFF3?)
;	    -if so: does stack have 1 value? > print that value > quit
;			if not, print "invalid Expression" > quit
;	2. is it opertor?
;	    -if so: pop 2 values > success = apply operand and push
;	    	                   fail = print error & quit
;	    -if not: push to stack
;	3. increment ptr, go back to step 1
;
EVALUATE

;initialize
	ST R1, EVAL_SaveR1	; R1 = ptr to the string
	ST R2, EVAL_SaveR2	; R2 = dereferenced string val
	ST R3, EVAL_SaveR3	; R3 = used for calculations
	ST R4, EVAL_SaveR4	; R4 = used for calculations
	ST R5, EVAL_SaveR5	; R5 = POP/PUSH success indicator
	ST R6, EVAL_SaveR6	; R6 = stores character to be checked(NewLine, etc)
	ST R7, EVAL_SaveR7	; R7 stores ret addr
	
Read_Val			;step 1: read one value. is it newline?
	LDR R2, R1, #0		; R2 <- M[R1]. Dereference pointer to stack ptr, load to R2.
	LD R6, CHAR_RETURN	;
	ADD R6, R6, R2		; is the value char_return decoded?
	BRz NewLine_Printed	; if so, go to NewLine_Printed(part of step 1)
	LD R6, NEW_LINE		; is the value newline decoded?
	ADD R6, R6, R2		; if so, go to NewLine_Printed(part of step 1)
	BRz NewLine_Printed	;

; is it an operator?

Which_Operator			; if operator, which operator is it?
	AND R3, R3, #0		; clear out R3 & 4 before any operators apply.
	AND R4, R4, #0		;
	LD R6, PLUS_SIGN	;
	ADD R6, R6, R2		; is it plus?
	BRz PLUS_OP		;  ->if so, pop 2 and apply -> push
	LD R6, MINUS_SIGN	; is it minus?
	ADD R6, R6, R2		;
	BRz MINUS_OP		; -> do the same
	LD R6, MULT_SIGN	; is it multiplication operator?
	ADD R6, R6, R2		; 
	BRz MULT_OP		;
	LD R6, DIV_SIGN		; is it division operator?
	ADD R6, R6, R2		; 
	BRz DIV_OP		;
	BR Eval_Operand		; if none of the operators, it's an operand 
	
PLUS_OP
	JSR POP			; pop the first value
	ADD R5, R5, #0		; if error, show message and halt
	BRp PRINT_ERROR		;
	ADD R3, R3, R0		; pop success; put first value in R3
	JSR POP			; pop 2nd value
	ADD R5, R5, #0		; if error, show message and halt
	BRp PRINT_ERROR		; 
	ADD R4, R4, R0		; pop success; put 2nd value in R4
	JSR PLUS		; do the operation
	JSR PUSH		; push the value back in stack
	BR OP_End		;
MINUS_OP
	JSR POP			; pop the first value
	ADD R5, R5, #0		; if error, show message and halt
	BRp PRINT_ERROR		;
	ADD R4, R4, R0		; pop success; put first value in R3
	JSR POP			; pop 2nd value
	ADD R5, R5, #0		; if error, show message and halt
	BRp PRINT_ERROR		; 
	ADD R3, R3, R0		; pop success; put 2nd value in R4
	JSR MINUS		; do the operation
	JSR PUSH		; push the value back in stack	
	BR OP_End		;
MULT_OP
	JSR POP			; pop the first value
	ADD R5, R5, #0		; if error, show message and halt
	BRp PRINT_ERROR		;
	ADD R3, R3, R0		; pop success; put first value in R3
	JSR POP			; pop 2nd value
	ADD R5, R5, #0		; if error, show message and halt
	BRp PRINT_ERROR		; 
	ADD R4, R4, R0		; pop success; put 2nd value in R4
	JSR MULTIPLY		; do the operation
	JSR PUSH		; push the value back in stack
	BR OP_End		;
DIV_OP
	JSR POP			; pop the first value
	ADD R5, R5, #0		; if error, show message and halt
	BRp PRINT_ERROR		;
	ADD R3, R3, R0		; pop success; put first value in R3
	JSR POP			; pop 2nd value
	ADD R5, R5, #0		; if error, show message and halt
	BRp PRINT_ERROR		; 
	ADD R4, R4, R0		; pop success; put 2nd value in R4
	ST R1, PTR_SAVE		; save ptr since R1 <- remainder
	JSR DIVIDE		; do the operation
	LD R1, PTR_SAVE		;
	JSR PUSH		; push the value back in stack
	BR OP_End		;

OP_End	ADD R1, R1, #1		; operation ended; increment ptr and
	BR Read_Val		; go read next value from string.

Eval_Operand
	ADD R1, R1, #1		; increment ptr
	AND R0, R0, #0		;
	ADD R0, R0, R2		;
	JSR PUSH		; Stack <- R2(value)
	BR Read_Val		; go read the next val

NewLine_Printed			; step 2. is there only 1 value in stack?
	JSR POP			;
	ADD R5, R5, #0		; was pop success?
	BRnp	PRINT_ERROR	; underflow; print error and halt
	JSR POP 		; successful pop -> invalid expression(means >1 val). 
	BRp EVAL_DONE		; fail pop -> halt.
	

PRINT_ERROR	
	LEA R0, ERROR_MSG
	PUTS
	HALT	;end program here to prevent "PRINT" from outputting junk

EVAL_DONE
	LD R1, EVAL_SaveR1
	LD R2, EVAL_SaveR2
	LD R1, EVAL_SaveR3
	LD R2, EVAL_SaveR4
	LD R5, EVAL_SaveR5
	LD R6, EVAL_SaveR6
	LD R7, EVAL_SaveR7
	RET

;data section
	PLUS_SIGN	.FILL x2B	; these, when added w/ decoded operators, should
	;MINUS_SIGN	.FILL x2D	; result in 0. use to check pop for diferent 
	MULT_SIGN	.FILL x2A	; operators. minus already declared elsewhere!
	DIV_SIGN	.FILL x2F
	OPERATOR_MASK	.FILL xF000	; operators have MSB of 1. AND and BRn to check.
	ERROR_MSG	.STRINGZ "Invalid Expression"	;
	EVAL_SaveR1	.BLKW #1
	EVAL_SaveR2	.BLKW #1
	EVAL_SaveR3	.BLKW #1
	EVAL_SaveR4	.BLKW #1
	EVAL_SaveR5	.BLKW #1
	EVAL_SaveR6	.BLKW #1
	EVAL_SaveR7	.BLKW #1
	PTR_SAVE	.BLKW #1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input: R3, R4
; out: R0
PLUS	
; your code goes here
	ADD R0, R3, R4	; R0 <- R3 + R4
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input: R3, R4
; out: R0
MINUS	
; your code goes here
	NOT R0, R4	; R0 <- -R4
	ADD R0, R0, #1	; 
	ADD R0, R3, R0	; R0 = R3 - R4
	RET	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input: R3, R4
; out: R0 = R3 x R4
MULTIPLY	
; your code goes here. 
	
	ST R3, MULTIPLY_SaveR3	
	ST R4, MULTIPLY_SaveR4

; determine output sign and take abs. val of neg. values
	AND R0, R0, #0	; R0 will hold output sign, before it is used for calculations
	ADD R3, R3, #0	; is R3 neg? if so mark output sign xFFFF and take abs val.
	BRp NXTSGN	; if positive, move onto R4 sign determination
	NOT R0, R0	; mark Output sign neg
	NOT R3, R3	; take abs val of R3
	ADD R3, R3, #1	; 
NXTSGN	ADD R4, R4, #0	; is R4 neg?
	BRp MULT_SIGN_DONE ; 
	NOT R0, R0	; flip output sign
	NOT R4, R4	; take abs val of R4
	ADD R4, R4, #1	; 	

MULT_SIGN_DONE
	ST R0, MULT_OUTSIGN ;

;actual multiplication. decrement R3, and add R4 to output each time. until R3=0
	AND R0, R0, #0	; clear R0
MULT_LP	ADD R3, R3, #0	; is R3 positive? then loop again.
	BRz MULT_RELOAD	; multiplication done; go reload
	ADD R0, R0, R4	;
	ADD R3, R3, #-1	; decrement R3
	BR MULT_LP	;

	LD R3, MULT_OUTSIGN ; should R0 be negative?
	ADD R3, R3, #0	    ;
	BRzp MULT_RELOAD    ; if zero/positive move on
	NOT R0, R0	    ; otherwise turn R0 negative
	ADD R0, R0, #1	    ;

MULT_RELOAD
	LD R3, MULTIPLY_SaveR3
	LD R4, MULTIPLY_SaveR4
	RET

MULTIPLY_SaveR3	.BLKW	#1	;
MULTIPLY_SaveR4	.BLKW	#1	;
MULT_OUTSIGN	.BLKW	#1	; if neg, output should be neg. if pos, pos.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input: R3, R4
; out: R0 - quotient (R0 = R3 / R4), R1 - remainder 
DIVIDE
; your code goes here

; Save values in R3~7
	ST R3, DIVIDE_SaveR3	; R3 holds original dividend(n)
	ST R4, DIVIDE_SaveR4	; R4 holds original divisor
	ST R5, DIVIDE_SaveR5	; R5 will be used for calculations
	ST R6, DIVIDE_SaveR6	; R6 will be used for calculations
	ST R7, DIVIDE_SaveR7	; hold in case of double JSR's

TAKE_ABSVAL			; takes abs.val of n and divisor, determine output signs
	ADD R3, R3, #0		; is the dividend(n) negative?
	BRzp skip		;
	AND R5, R5, #0		; clear R5 for calculations
	NOT R5, R5		; if so, resulting remainder should be negative
	ST R5, REM_SIGN		; REM_SIGN = xFFFF indicates remainder should be neg.
	NOT R3, R3		; R3 <- Abs.val(R3)
	ADD R3, R3, #1		;
skip				; now to the divisor. if R3 and R4 have diff. signs, 
				; quotient is negative.
	ADD R4, R4, #0		; is R4 positive?
	BRn neg			;
pos	ADD R5, R5, #0		; is R3 negative?(R3 sign != R4 sign) aka neg quotient
	BRzp DIVISION		; both are positive; move onto actual division
	BR difsign		;
neg	NOT R4, R4		; R4 <- abs.val(R4)
	ADD R4, R4, #1		; 
	ADD R5, R5, #0		; R4 is negative. is orig R3 positive?
	BRzp difsign		; 
	BR DIVISION		; Nope. Go do actual division.
difsign 
	AND R5, R5, #0		;
	NOT R5, R5		;
	ST R5, QUO_SIGN		; Quotient sign is negative.

DIVISION
	AND R0, R0, #0		; clear R0
	AND R1, R1, #0		; clear R1
	AND R5, R5, #0		; clear R5 for calculations
	NOT R5, R4		; R5 = -R4. R3-R4 and increment R0 until done.
	ADD R5, R5, #1		; 
divLoop	AND R6, R6, #0		; clear R6 for calculations
	ADD R6, R3, R5		; R6 = R3 - R4. is R3 >= R4?
	BRn SIGN_CHANGE		; if not, halt division and move onto sign change
	ADD R3, R3, R5		; R3 = R3 - R4
	ADD R0, R0, #1		; quotient++
	BR divLoop		;

SIGN_CHANGE
	ADD R1, R1, R3		; R1 <- remainder(R3)
	LD R5, QUO_SIGN		; Should Quotient be negative?
	BRzp remSign		; move onto change remainder sign
	NOT R0, R0		; quotient is negative.
	ADD R0, R0, #1		; 
remSign LD R5, REM_SIGN		; Should Remainder be negative?
	BRzp Divide_reload	; if not, exit subroutine
	NOT R1, R1		; R1 <- -R1
	ADD R1, R1, #1		;

Divide_reload
	LD R3, DIVIDE_SaveR3	;
	LD R4, DIVIDE_SaveR4	;
	LD R5, DIVIDE_SaveR5	;
	LD R6, DIVIDE_SaveR6	;
	LD R7, DIVIDE_SaveR7	;
	RET			; exit subroutine

DIVIDE_SaveR3	.BLKW #1	;
DIVIDE_SaveR4	.BLKW #1	;
DIVIDE_SaveR5	.BLKW #1	;
DIVIDE_SaveR6	.BLKW #1	;
DIVIDE_SaveR7	.BLKW #1  	; save return point

QUO_SIGN	.BLKW #1 	; if xFFFF, quotient should be negative
REM_SIGN	.BLKW #1	; if xFFFF, remainder should be negative

; IN: R0
; OUT: R5 (0-success, 1-fail/overflow)
; R3: STACK_END R4: STACK_TOP
;
PUSH	
	ST R3, PUSH_SaveR3	; save R3
	ST R4, PUSH_SaveR4	; save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACk_TOP	;
	ADD R3, R3, #-1		;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz OVERFLOW		; stack is full
	STR R0, R4, #0		; no overflow, store value in the stack
	ADD R4, R4, #-1		; move top of the stack
	ST R4, STACK_TOP	; store top of stack pointer
	BRnzp DONE_PUSH		;
OVERFLOW
	ADD R5, R5, #1		;
DONE_PUSH
	LD R3, PUSH_SaveR3	;
	LD R4, PUSH_SaveR4	;
	RET

PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;


; OUT: R0, R5 (0-success, 1-fail/underflow)
; R3 STACK_START R4 STACK_TOP
;
POP	
	ST R3, POP_SaveR3	; save R3
	ST R4, POP_SaveR4	; save R3
	AND R5, R5, #0		; clear R5
	LD R3, STACK_START	;
	LD R4, STACK_TOP	;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz UNDERFLOW		;
	ADD R4, R4, #1		;
	LDR R0, R4, #0		;
	ST R4, STACK_TOP	;
	BRnzp DONE_POP		;
UNDERFLOW
	ADD R5, R5, #1		;
DONE_POP
	LD R3, POP_SaveR3	;
	LD R4, POP_SaveR4	;
	RET

POP_SaveR3	.BLKW #1	;
POP_SaveR4	.BLKW #1	;

STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;


.END
