
.ORIG x3000

; main code goes here

; IMPLEMENT ME!
    ; setup arguments and
    ; call RNG
		LD R0, a
		LD R1, c
		LD R2, m
		LD R3, seed
		LD R4, N
		LD R5, addr
		JSR RNG
    HALT

; LCG model parameters
a .FILL #4
c .FILL #1
m .FILL #9
seed .FILL #0  ; aka X0

; number and address of random numbers to generate
N .FILL #9
addr .FILL x4000


; RNG subroutine implementation 
; stores a series of LCG's in mmr starting @ location specified in R5
RNG
    ; IMPLEMENT ME
	; print series of N LCG's
	; R6 used as counter, then decrease each time you jsr to LCG.
	; when counter reaches -1, halt

	;NOTE: REGRADE REQUEST
	; everything on  this part 2 received full credit, except for implementation of RNG.
	; previously, I had written a detailed algorithm, but couldn't implement it out
	; due to lack of time. (debugging pt 1). I have implemented it  now, within a 
	; very short period of time.. the program is working as intended. please! I need those
	; points back..
	

;;FROM HERE, 11 LINES OF INSTRUCTIONS WERE ADDED FOR REGRADE REQUEST!sorry I committed here..

	ST R7, RNG_SaveR7 ; save R7
	ST R5, RNG_SaveR5 ; save ptr to mmr
	ADD R6, R4, #1	  ; R6 = N+1

;loop through N times
RNG_LOOP	
	ADD R6, R6, #-1 ; loop N times
	BRz RNG_DONE
	JSR LCG
	STR R3, R5, #0 ; store Xn into mmr
	ADD R5, R5, #1 ; increment mmr ptr
	BR RNG_LOOP
RNG_DONE
	LD R7, RNG_SaveR7 ;
	LD R5, RNG_SaveR5
    RET

RNG_SaveR7 .BLKW #1 ;
RNG_SaveR5 .BLKW #1 ; 

; LCG subroutine implementation
; OUT: R3 - newly generated number
; R6 used for calculations
LCG
    ; IMPLEMENT ME
		ST R0, Savea	;
		ST R1, Savec	;
		ST R2, Savem	;
		ST R3, Saveseed	;
		ST R7, LCG_SaveR7
		ST R6, LCG_SaveR6

		AND R6, R6, #0	;
		ADD R1, R3, #0	;  MULT a * Xn = a * R3
		ADD R2, R0, #0	;
		JSR MULT		; R0 = a * Xn
		LD R1, Savec	;
		ADD R0, R0, R1	; R0 = (a*Xn + c)
		ADD R1, R0, #0	; do R0 mod m
		LD R2, Savem	;
		JSR DIVIDE		; R3 holds the final output

		LD R0, Savea	;
		LD R1, Savec	;
		LD R2, Savem	;
		LD R7, LCG_SaveR7
		LD R6, LCG_SaveR6
    RET
LCG_SaveR6 .BLKW #1 ;
LCG_SaveR7	.BLKW #1
Savea	.BLKW #1
Savec	.BLKW #1
Savem	.BLKW #1
Saveseed .BLKW #1

; Do Not Write Below This Line!
; ----------------------------------

; DIVIDE - divides R1 by R2 and returns R0 and R3
; IN:  R1: numerator (dividend, N)
;      R2: denominator (divisor, D)
;      (R1 and R2 must be strictly > 0)
; OUT: R0: quotient, Q (Q = N / D)
;      R3: remainder, R 
;
DIVIDE

     AND R0, R0, #0 ; intialize quotient, Q <- 0
     ADD R3, R1, #0 ; initialize remainder, R <- N

     ST R5, DIV_SaveR5
     ST R6, DIV_SaveR6

     ; precompute -D
     NOT R6, R2
     ADD R6, R6, #1   ; R6 <- D

; while R >= D
LOOP ADD R5, R3, R6  ; R - D
     BRn DONE
     ADD R0, R0, #1 ; Q <- Q + 1
     ADD R3, R3, R6 ; R <- R - D
     BR LOOP

DONE 
     LD R5, DIV_SaveR5
     LD R6, DIV_SaveR6

    RET

; data
DIV_SaveR5 .BLKW #1
DIV_SaveR6 .BLKW #1


; MULT multiplies two numbers
; IN: R1, R2 (R2 must be strictly > 0)
; OUT: R0 <- R1 * R2
;
MULT
     ST R2, MULT_SaveR2

     AND R0, R0, #0   ; clear result
LOOP1 ADD R0, R0, R1   ; add R1 to partial sum
     ADD R2, R2, #-1  ; decrement R2
     BRp LOOP1         ; and check if it is still positive

     LD R2, MULT_SaveR2

     RET

; data
MULT_SaveR2 .BLKW #1


.END


