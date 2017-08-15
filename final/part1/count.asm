.ORIG x3000

; int CountNodes(node *nd, int parent_value);
COUNT_NODES

    ; Allocate space for return value
    ADD R6, R6, #-1

    ; Push return address to stack
    ADD R6, R6, #-1
    STR R7, R6, #0

    ; Store callee's frame pointer
    ADD R6, R6, #-1
    STR R5, R6, #0

    ; Set up new frame pointer
    ADD R5, R6, #-1

    ; Add space for local vars
    ADD R6, R6, #-1

    ; count = 0;
G1S ; ---- IMPLEMENT ME (1 point)
    AND R0, R0, #0
	STR R0, R6, #0 ; store count = 0 at top of the stack

G1E ; write your code between G1S and G1E

    ; if (nd == NULL) return 0;

    ; check if nd != NULL
    LDR R0, R5, #4 ; R0 <- nd
    BRnp CONTINUE1

    ; nd == NULL, thus, return 0

    ; store 0 ret. val.
    AND R0, R0, #0
    STR R0, R5, #3

    ; Discard local variables
    ADD R6, R6, #1

    ; Restore frame pointer
    LDR R5, R6, #0
    ADD R6, R6, #1

    ; Restore return address
    LDR R7, R6, #0
    ADD R6, R6, #1    
 
    RET

CONTINUE1
    ; if (nd->value > parent_value) count = 1;

    ; load nd->value into R0
G2S ; ---- IMPLEMENT ME  (1 point)
    LDR R0, R5, #4 ; R0 <- nd
    LDR R0, R0, #0 ; R0 <- nd->value

G2E ; write your code between G2S and G2E

    ; load parent_value into R1
G3S ; ---- IMPLEMENT ME  (2 points)
    LDR R1, R5, #5 ; R0 <- parent value


G3E ; write your code between G3S and G3E

    ; compute R0 <- (nd->value - parent_value)
    NOT R1, R1
    ADD R1, R1, #1
    ADD R0, R0, R1

    ; if positive, count = 1
    BRnz CONTINUE2

    ; count = 1
G4S ; ---- IMPLEMENT ME  (2 points)
    AND R2, R2, #0 ; 
	ADD R2, R2, #1 ; R2 holds 1
    STR R2, R5, #0 ; count <- 1

G4E ; write your code between G4S and G4E

CONTINUE2
    ; count += CountNodes(nd->left, nd->value);

    ; read and push onto the stack nd->value
G5S ; ---- IMPLEMENT ME  (2 points)
    ADD R6, R6, #-1 ; make space to push nd->val
    LDR R0, R5, #4 ; 
	LDR R0, R0, #0 ; R0 <- nd->value
	STR R0, R6, #0 ; push nd->value


G5E ; write your code between G5S and G5E

    ; read and push onto the stack nd->left
G6S ; ---- IMPLEMENT ME  (3 points)
    ADD R6, R6, #-1 ; make space to push nd->left
	LDR R0, R5, #4 ; 
	LDR R0, R0, #1 ; R0 <- nd->left
	STR R0, R6, #0 ; push nd->left onto stack


G6E ; write your code between G6S and G6E

    ; call subroutine
    JSR COUNT_NODES

    ; count += ret.val.
G7S ; ---- IMPLEMENT ME  (2 points)
    LDR R0, R5, #0 ; R0 <- count
	LDR R1, R5, #3 ; R1 <- ret.val
	ADD R0, R0, R1 ; R0 <- count + ret.val
    STR R0, R5, #0 ; store updated count back into its location


G7E ; write your code between G7S and G7E

    ; pop retval and arguments from the stack
    ADD R6, R6, #3

    ; count += CountNodes(nd->right, nd->value);

    ; read and push onto the stack nd->value
G8S ; ---- IMPLEMENT ME  (2 points)
    ADD R6, R6, #-1 ; make space to push nd->val
    LDR R0, R5, #4 ; 
	LDR R0, R0, #0 ; R0 <- nd->value
	STR R0, R6, #0 ; push nd->value


G8E ; write your code between G8S and G8E

    ; read and push onto the stack nd->right
G9S ; ---- IMPLEMENT ME  (3 points)
    ADD R6, R6, #-1 ; make space to push nd->right
	LDR R0, R5, #4 ; 
	LDR R0, R0, #2 ; R0 <- nd->right
	STR R0, R6, #0 ; push nd->right onto stack



G9E ; write your code between G9S and G9E

    ; call subroutine
    JSR COUNT_NODES

    ; count += ret.val.
G10S ; ---- IMPLEMENT ME  (2 points)
    LDR R0, R5, #0 ; R0 <- count
	LDR R1, R5, #3 ; R1 <- ret.val
	ADD R0, R0, R1 ; R0 <- count + ret.val
    STR R0, R5, #0 ; store updated count back into its location


G10E ; write your code between G10S and G10E

    ; pop retval and arguments from the stack
    ADD R6, R6, #3

    ; return count

    ; store count in ret.val. place
    LDR R0, R5, #0
    STR R0, R5, #3

    ; Discard local variables
    ADD R6, R6, #1

    ; Restore frame pointer
    LDR R5, R6, #0
    ADD R6, R6, #1

    ; Restore return address
    LDR R7, R6, #0
    ADD R6, R6, #1    
 
    RET

.END

