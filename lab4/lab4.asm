; Print signed decimal value
;
;
;
.ORIG x3000

; test code goes here, e.g.,
; R0 <- 12342
; JSR PRINT
; R0 <- -9832
; JSR PRINT
	

HALT


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine should print value stored in register R0 in decimal format
; input: R0 - holds the input
; output: signed decimal value printed on the display
; algorithm:
;	0. is the value negative? if so take note and take abs value of input.
;	1. divide value store in R0 by 10. Store quotient in R0, push rem to stack.
;	2. If quotient(R0) is not 0, go to step 1
;	3a.if the input was negative, print out a minus sign. 
;	3b.Pop values of stack one at a time til stack is empty. ADD ascii offset
;	   for '0' and print to screen.
PRINT
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
ZERO		.FILL x30	;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input: R3, R4
; out: R0 - quotient (R0 = R3 / R4), R1 - remainder 
; algorithm:
;	If R3 and R4 are negative, then take abs. val of them. 
;	then determine signs of outcomes, based on the fact that:
;	 1. dividend(n) and remainder has the same sign
;	 2. if divisor & dividend signs disagree, then quotient is negative.
;	subtract R4 from R3 and increment R0, until R4 > R3. Then R3->R1
;	If R5 was 1, then turn both quotient and remainder negative.
;	
DIVIDE

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

; ======== PUSH/POP subroutines 

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
