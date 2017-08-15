.ORIG x3000

; setup minimal activation record for main
; =============
; init stack top
LD R6, STACK
ADD R6, R6, #1 ; stack is empty

; init frame pointer
LD R5, STACK ; first memory location available for local vars
; =============

; int a, b, c
ADD R6, R6, #-3

; a = 5;
AND R0, R0, #0
ADD R0, R0, #5
STR R0, R5, #0 ; push a onto stack

; b = -1;
AND R0, R0, #0
ADD R0, R0, #-1
STR R0, R5, #-1 ; push b onto stack


;passing a & b into callee's activation record
LDR R0, R5, #0 ; R0 = a
ADD R6, R6, #-1
STR R0, R6, #0 ; push a into act. record of myF
LDR R0, R5, #-1 ; R0 = b
ADD R6, R6, #-1
STR R0, R6, #0 

; call function. R7 <- PC
JSR MYF

; c = retval
LDR R0, R6, #0 ; R0 <- ret val
ADD R6, R6, #1 ; pop ret val
STR R0, R5, #-2 ; store a+b in c

ADD R6, R6, #2 ; pop params a,b


; destroy minimal activation record for main
; ============
; pop a and be before returning from main
ADD R6, R6, #3
; ============

; stop main
HALT

STACK .FILL x30FF

; myf implementation
MYF
; push bookkeeping info onto stack
ADD R6, R6, #-1 ; add space for ret val
ADD R6, R6, #-1 ; push R7
STR R7, R6, #0
ADD R6, R6, #-1 ; push R5(frame ptr)
STR R5, R6, #0

; setup new frame pointer
ADD R5, R6, #-1

; R0 = a + b
AND R0, R0, #0
LDR R1, R5, #4
ADD R0, R0, R1
LDR R1, R5, #5
ADD R0, R0, R1

; return a+b (R0)
; prepare ret val
STR R0, R5, #3

;restore R5 and R7
LDR R5, R6, #0 ; pop R5
ADD R6, R6, #1
LDR R7, R6, #0 ; pop R7
ADD R6, R6, #1

; return
RET

.END




