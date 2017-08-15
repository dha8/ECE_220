

.ORIG x4000

;void inorder (BTREE root)
;{
;/* your code goes here */
;    if(root == NULL) return;
;    inorder(root->left);
;    printf("%c ",root->d);
;    inorder(root->right);
;}

; implement this subroutine following the run-time stack convention presented in lectures
; use OUT trap to print 
INORDER

; allocate space for retval
    ADD R6, R6, #-1

;push ret addr to stack
    ADD R6, R6, #-1
    STR R7, R6, #0

;store caller's frame ptr
    ADD R6, R6, #-1
    STR R5, R6, #0

;set up new frame ptr
    ADD R5, R6, #-1

;begin the fxn
;if(root == NULL) return;
    LDR R0, R5, #4
    BRz DONE

;inorder(root->left);
    LDR R0, R5, #4  ;R0 <- root
    LDR R1, R0, #1  ;R1 <- root->left

;push root->left to stack
    ADD R6, R6, #-1
    STR R1, R6, #0

;call subroutine
    JSR INORDER

;tear-down the rest of the stack
    ADD R6, R6, #2 ; 

;printf("%c ",root->d);
    LDR R0, R5, #4 ; R0 <- root
    LDR R0, R0, #0 ; R0 <- root->data
    OUT
    
;inorder(root->right);
    LDR R0, R5, #4 ; R0 <- root
    LDR R2, R0, #2 ; R0 <- root->right;

;push root->right to stack
    ADD R6, R6, #-1
    STR R2, R6, #0

;call subroutine
    JSR INORDER

;tear-down the rest of the stack
    ADD R6, R6, #2 ; 
    
DONE
    ;restore frame ptr
    LDR R5, R6, #0
    ADD R6, R6, #1
    ;restore return addr
    LDR R7, R6, #0
    ADD R6, R6, #1

RET


.END
