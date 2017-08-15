
.ORIG x3000

; main code goes here
		JSR IS_VALID


    HALT


; IS_VALID subroutine implementation goes here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;read in series of string until enter(xD) is input, and 
;returns 1 if it is valid, 0 if not.
;IN: -
;OUT: R0 (1 or 0)
;Usage:
;	R0 - output(isvalid or not)
;	R1 - Keyboard input(KBSR, then data from KBDR)
;	R2 - checks lowercase & uppercase & also in step 2b
;	R3 - holds offset between lower & upper. 'a'-'A'. add to upper to get lower
;	R4&5 - used for output(R4) & calculations for upper & lowercase conversion
;		R4 also temp holder for R0
;	R6 used for R0's placeholder -> nvm use mmr instd
;	R7 - for ret addr
IS_VALID
; save values
		ST R1, ISVAL_SaveR1
		ST R2, ISVAL_SaveR2
		ST R3, ISVAL_SaveR3
		ST R4, ISVAL_SaveR4
		ST R5, ISVAL_SaveR5
		ST R6, ISVAL_SaveR6
		ST R7, ISVAL_SaveR7

; initialization
		LD R3, ASCII_la	; Calculate offset for upper & lower.
		LD R4, ASCII_uA ;
		NOT R4, R4		;
		ADD R4, R4, #1	;
		ADD R3, R3, R4	; R3 now holds the offset between l & u. 'a'-'A'.

; step 0: set R0 <- 1
		AND R0, R0, #0	;
		ADD R0, R0, #1	;
		
; step 1: read 1 character from keyboard
LOOP1	LDI R1, KBSR ; R1 gets value stored at KBSR
		BRzp LOOP1	 ; wait until new kb input
		LDI R1, KBDR ; R1 gets data from keyboard
LOOP2	LDI R4, DSR	 ; 
		BRzp LOOP2	 ;
		STI R1, DDR	 ;

; step 2: check entered char.
Chk_Chr LD R2, ASCII_ENTER	; is it enter?
		NOT R2, R2		;
		ADD R2, R2, #1	;
		ADD R2, R2, R1	;
		BRz ENTERED		;

		LD R2, ASCII_la	; R2 <- 'a'
		NOT R2, R2	 	;
		ADD R2, R2, #1	; R2 <- -'a'
		ADD R2, R2, R1	; R2 <- input - lower'a'
		BRn UPPER		; negative values indicate value was upper
LOWER	ST R0, R0_HOLDER ; temp save R0
		ADD R0, R0, R1  ; R0 now holds R1(input)
		JSR PUSH		; step 2a: lowercase -> push val onto stack
		LD R0, R0_HOLDER ; restore R0
		;;;;;THEN WHAT? get next value?
		BR LOOP1		; get next val
UPPER	ST R0, R0_HOLDER
		JSR POP			; step 2b: pop from stack into R0
		AND R2, R2, #0	; clr R2 to chk for corresponding lower case
		ADD R2, R2, R0	; R2 now holds popped data
		;does R0(popped) hold lower case of value stored at R1(input)?
		ADD R4, R1, R3	; R4 holds lowercase of R1(input)
		NOT R5, R4		; R5 = R0 - lowercase(R1)
		ADD R5, R5, #1	;
		ADD R5, R5, R0	; 
		BRz	toLOOP1		; is lowercase! to step one.before that, restor orig R0
		AND R0, R0, #0	;
		BR LOOP1		;
toLOOP1 AND R0, R0, #0	;
		LD R0, R0_HOLDER
		BR LOOP1

ENTERED	; is stack empty?
		ST R0, R0_HOLDER
		JSR POP
		ADD R5, R5, #0	; check if it was empty(pos indicates so)
		BRp EMPTY
		JSR PUSH		; if it wasnt empty, push the popped value
		AND R0, R0, #0	; clear R0
		BR DONE         ; and return
EMPTY	AND R0, R0, #0	;
		LD R0, R0_HOLDER

DONE
		LD R1, ISVAL_SaveR1
		LD R2, ISVAL_SaveR2
		LD R3, ISVAL_SaveR3
		LD R4, ISVAL_SaveR4
		LD R5, ISVAL_SaveR5
		LD R6, ISVAL_SaveR6
		LD R7, ISVAL_SaveR7

    RET

R0_HOLDER	.BLKW #1
ASCII_ENTER .FILL xD

ASCII_la .FILL x61  ; ASCII value for 'a'
ASCII_lz .FILL x7A  ; ASCII value for 'z'
ASCII_uA .FILL x41  ; ASCII value for 'A'
ASCII_uZ .FILL x5A  ; ASCII value for 'Z'

KBSR .FILL xFE00
KBDR .FILL xFE02
DSR  .FILL xFE04
DDR  .FILL xFE06

ISVAL_SaveR1 .BLKW #1
ISVAL_SaveR2 .BLKW #1
ISVAL_SaveR3 .BLKW #1
ISVAL_SaveR4 .BLKW #1
ISVAL_SaveR5 .BLKW #1
ISVAL_SaveR6 .BLKW #1
ISVAL_SaveR7 .BLKW #1

; Do Not Write Below This Line!
; ----------------------------------

; PUSH onto the stack 
; IN: R0
; OUT: R5 (0-success, 1-fail/overflow)
; Used registers: R3: STACK_END R4: STACK_TOP
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


; POP from the stack
; OUT: R0, R5 (0-success, 1-fail/underflow)
; Used registers: R3 STACK_START R4 STACK_TOP
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



