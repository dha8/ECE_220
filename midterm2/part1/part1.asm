.ORIG x3000

;int main()
;{
;    int a, b=5;
;    int array[5] = { 5, 4, 3, 2, 1 };
;
;    a = function(array, &b);
;
;    printf("a=%d, b=%d\n", a, b);
;
;    return 0;
;}
MAIN
    ; setup stack
    LD R5, STACKTOP   ; R5 - frame pointer for main()
    LD R6, STACKTOP   ; R6 - ToS pointer
    ADD R6 , R6 , #1  ; stack is initially empty

    ; allocate and initalize local variables
    ADD R6, R6, #-1  ; push a

    ADD R6, R6, #-1  ; push b

    AND R0, R0, #0   ; b = 5;
    ADD R0, R0, #5
    STR R0, R6, #0

    ADD R6, R6, #-5  ; push array

    AND R0, R0, #0
    ADD R0, R0, #5   ; array[0]=5
    STR R0, R6, #0
    ADD R0, R0, #-1   ; array[1]=4
    STR R0, R6, #1
    ADD R0, R0, #-1   ; array[2]=3
    STR R0, R6, #2
    ADD R0, R0, #-1   ; array[3]=2
    STR R0, R6, #3
    ADD R0, R0, #-1   ; array[4]=1
    STR R0, R6, #4

    ; call subroutine

    ; IMPLEMENT THIS: push &b onto the stack  
; ----- place your code between these lines only ----
		ADD R6, R6, #-1
		ADD R0, R5, #-1 ;
		STR R0, R6, #0

; ----- place your code between these lines only ----

STOP1 ; <- do not comment out or modify this label! it is needed for grading

    ; IMPLEMENT THIS: push array base address onto the stack 
; ----- place your code between these lines ----
		ADD R6, R6, #-1
		AND R0, R0, #0
		ADD R0, R6, #2 ; R0 holds base addr of array
		STR R0, R6, #0
; ----- place your code between these lines ----

STOP2 ; <- do not comment out or modify this label! it is needed for grading

    ; call subroutine
    JSR FUNCTION

    ; get return value
    LDR R0, R6, #0
    ADD R6, R6, #1 ; pop return value
    STR R0, R5, #0 ; a = return value

    ; ignore printf("a=%d, b=%d\n", a, b);

    ; free stack
    ADD R6, R6, #2 ; pop arguments
    ADD R6, R6, #7 ; pop local variables

HALT           ; return

STACKTOP .FILL x30FF


;int function(int array[], int *n)
;{
;    /* terminal case */
;    if (*n == 0) return 0;
;
;    /* reduction case */
;    *n = *n - 1;
;    return array[*n] + function(array, n);
;}
FUNCTION
    ; IMPLEMENT THIS: push bookkeeping info onto the stack
; ----- place your code between these lines only ----
		ADD R6, R6, #-1 ; space for retval
		ADD R6, R6, #-1 
		STR R7, R6, #0 ; store return addr
		ADD R6, R6, #-1 ;
		STR R5, R6, #0 ; store frame ptr
; ----- place your code between these lines only ----

STOP3 ; <- do not comment out or modify this label! it is needed for grading

    ; setup frame pointer
    ADD R5, R6, #-1

TERMINAL_CASE
    ;    /* terminal case */
    ;    if (*n == 0) return 0;
    LDR R0, R5, #5
    LDR R1, R0, #0
    BRp REDUCTION_CASE
    ; return 0
    AND R0, R0, #0
    STR R0, R5, #3
    BR DOWN

REDUCTION_CASE
    ;    /* reduction case */
    ; IMPLEMENT THIS: *n = *n - 1;
; ----- place your code between these lines only ----
		ADD R1, R1, #-1 ; *n = *n - 1;
		STR R1, R0, #0 ; save *n-1 into addr(b)
; ----- place your code between these lines only ----

STOP4 ; <- do not comment out or modify this label! it is needed for grading

    ;    return array[*n] + function(array, n);
    ; IMPLEMENT THIS: R0 <- array[*n]
; ----- place your code between these lines only ----
        LDR R0, R5, #5 ;
        LDR R1, R0, #0 ; R1 <- *n
		LDR R2, R5, #4 ; R2 points to start of arr
		ADD R2, R2, R1 ; R2 points to array[*n]
		LDR R0, R2, #0 ; R0 holds value @ array[*n]
; ----- place your code between these lines only ----

STOP5 ; <- do not comment out or modify this label! it is needed for grading

    ; temporary store array[*n] (R0) on the stack
    STR R0, R5, #3   ; save array[*n] in temp storage

    ; setup function call
    LDR R0, R5, #5
    ADD R6, R6, #-1
    STR R0, R6, #0

    LDR R0, R5, #4
    ADD R6, R6, #-1
    STR R0, R6, #0

    JSR FUNCTION

STOP6 ; <- do not comment out or modify this label! it is needed for grading

    ; IMPLEMENT THIS: get return value 
                     ; R0 <- function(array, n)
                     ; pop return value and 2 function arguments
; ----- place your code between these lines only ----
		LDR R0, R6, #0 ; get ret var
        ADD R6, R6, #1 ; pop retval
		ADD R6, R6, #2 ; pop 2 function args
; ----- place your code between these lines only ----

STOP7 ; <- do not comment out or modify this label! it is needed for grading

    LDR R1, R5, #3   ; read array[*n] from temp storage

    ADD R0, R0, R1   ; R0 <- array[*n] + function(array, n)
    STR R0, R5, #3   ; store return value  

DOWN
    ; restore R5/R7 and return
    LDR R5, R6, #0
    ADD R6, R6, #1 ; pop R5
    LDR R7, R6, #0
    ADD R6, R6, #1 ; pop R7
RET


.END


