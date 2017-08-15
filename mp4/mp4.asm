.ORIG x3000

;;R5 - frame pointer
;;R6 - stack pointer

;;MAIN - DO NOT CHANGE ANY CODE HERE
  LD R6, STACK
  LD R5, STACK

  ADD R6, R6, #-2 ; make space for local variables

  ; fake scanf("%d %d", &x, &y); 
  LD R0, X_VAL
  STR R0, R5, #0 ; x <- 5
  LD R0, Y_VAL
  STR R0, R5, #-1 ; y <- 4
  
;;CALL FOO1 SUBROUTINE - DO NOT CHANGE ANY CODE HERE
  ADD R6, R6, #-1  ; push address of y on to run-time stack
  ADD R3, R5, #-1
  STR R3, R6, #0   
  ADD R6, R6, #-1  ; push address of x on to run-time stack
  STR R5, R6, #0   

  JSR FOO1
;; NOTE: WOULD HAVE ASSIGNED VAL OF Z HERE, BUT THE COMMENTS INDICATE THAT I DO NOT! this is the reason why x3FFG doesn't actually contain value of Z. I have confirmed with professor and he said its fine.

;;STACK TEAR-DOWN FOR FOO1 - DO NOT CHANGE ANY CODE HERE
  LDR R0, R6, #0
  ST R0, Z_VAL     ; fake printf("z = %d\n", z);
  ADD R6, R6, #3   ; pop retval and parameters from the stack
 
;;“return 0“ - DO NOT CHANGE ANY CODE HERE
  ADD R6, R6, #3
HALT

STACK .FILL x4000

X_VAL .FILL x5
Y_VAL .FILL x4
Z_VAL .BLKW #1



 
;;IMPLEMENT ME: FOO1 SUBROUTINE
;; Below are implementations for Foo1 and Foo2, functions called within main.
;; main calls foo1 which calls foo2, meaning that stack is formed that way.
;; The contents of stack is as following(instant @ the end of Foo1):
;; x, y(local var from main stack), spot for z, addr of y and x(fxn param for
;; foo1 from right to left), retval, ret addr, stack frame of foo1
;; (bookkeeping info), then local var of foo1(aka total), then foo2's stack.
;; which includes *y, total(parameters), then its bookkeeping info. After each
;; iteration of foo2 called by loop in foo1, stack is broken down and built up.
;; when foo1 finishes, its stack is broken down.

FOO1
 ADD R6, R6, #-1 ; leave space for ret val
 ADD R6, R6, #-1 ; space for ret addr (R7)
 STR R7, R6, #0  ; push R7
 ADD R6, R6, #-1 ; space for stack frame ptr
 STR R5, R6, #0  ; push R5
 ADD R5, R6, #-1 ; update stack frame ptr	
 AND R0, R0, #0  ; initialize total = 0
 ADD R6, R6, #-1 ; 
 STR R0, R6, #0  ; push total = 0 onto stack
 
 ;entering for loop
 FOO1_LOOP
 ; fetch value stored @x, BRnz -> exit loop & return.
 ; else total = foo2(total, *y) and decrement val stored at x.
 ; then BR to beginning of loop
 LDR R0, R5, #4 ; R0 <- &x
 LDR R0, R0, #0 ; R0 <- *x
 BRnz EXITLOOP

 ; since *x>0, call total = foo2(total, *y)
 ; pass parameters
 LDR R0, R5, #5 ; get &y
 LDR R0, R0, #0 ; get *y
 ADD R6, R6, #-1  
 STR R0, R6, #0 ; push *y
 LDR R0, R5, #0 ; get total
 ADD R6, R6, #-1 
 STR R0, R6, #0 ; push total
 JSR FOO2

 ;get newly returned value into R0 
 LDR R0, R6, #0 ; R0 <- retval(foo2)
 ADD R6, R6, #1 ; pop retval
 STR R0, R5, #0 ; update retval into total

 ;pop local variables
 ADD R6, R6, #2 ; now both R5, R6 @ x3FF8(total)

 STR R0, R5, #3 ; update the retval of foo1
 ;decrement *x
 LDR R0, R5, #4 ; R0 = &x
 LDR R0, R0, #0 ; R0 = *x
 ADD R0, R0, #-1 ; decrementing *x
 LDR R1, R5, #4 ; R0 = &x
 STR R0, R1, #0 ; saving newly decremented *x


 ;go to next iteration
 BR FOO1_LOOP

 EXITLOOP ; return total
 ADD R6, R6, #1 ; pop local var
 LDR R5, R6, #0 ; restore R5 // kinda unsure here. check for dbging
 ADD R6, R6, #1 ; pop frame ptr
 LDR R7, R6, #0 ; restore ret addr
 ADD R6, R6, #1 ; pop ret addr

RET

;;IMPLEMENT ME: FOO2 SUBROUTINE
FOO2
 ADD R6, R6, #-1 ; leave space for retval
 ADD R6, R6, #-1
 STR R7, R6, #0  ; push ret addr onto stack
 ADD R6, R6, #-1
 STR R5, R6, #0  ; push stack frame onto stack
 ADD R5, R6, #-1 ; set new frame ptr 
 
 ;ret currentTotal + y
 LDR R0, R5, #4 ; R0 <- total
 LDR R1, R5, #5 ; R1 <- *y
 ADD R0, R0, R1 ; total += *y

 ;set retval to R0
 STR R0, R5, #3 ; set return value
 LDR R5, R6, #0 ; reload R5
 ADD R6, R6, #1 ; pop frame ptr
 LDR R7, R6, #0 ; reload R7
 ADD R6, R6, #1 ; pop ret addr


RET

.END
