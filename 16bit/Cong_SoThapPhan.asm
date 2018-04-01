.MODEL SMALL
.STACK 100H
.DATA
    NUM1 DW 0
    NUM2 DW 0
    MSG1 DB 'INPUT NUM1:', 13, 10, '$'
    MSG2 DB 13, 10, 'INPUT NUM2:', 13, 10, '$'
    MSG3 DB 13, 10, 'SUM:', 13, 10, '$'
.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; INPUT NUM1
    MOV AH, 9
    LEA DX, MSG1
    INT 21H
    CALL INPUT_PROC
    MOV AX, NUM2
    MOV NUM1, AX
    
    ;INPUT NUM2
    MOV AH, 9
    LEA DX, MSG2
    INT 21H
    CALL INPUT_PROC
    
SUM_:
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    MOV AX, NUM1
    ADD AX, NUM2
    
    XOR CX, CX
    MOV BX, 10    
OUTPUT_:    
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE OUTPUT_
    MOV AH, 2
    
DISPLAY_:
    POP DX
    OR DL, 30H
    INT 21H
    LOOP DISPLAY_
    
    MOV DX, 13
    INT 21H
    MOV DX, 10
    INT 21H
    
MAIN ENDP

INPUT_PROC PROC
    
    MOV AH, 1
    MOV BX, 0
    MOV NUM2, 0
    
INPUT_NUM:

    INT 21H
    CMP AL, 13
    JE STOP_
    INC BX
    AND AX, 000FH
    PUSH AX
    MOV AX, 10
    MUL NUM2
    MOV NUM2, AX
    POP AX
    ADD NUM2, AX
    MOV AH, 1
    JMP INPUT_NUM
    
STOP_:

    RET
    
INPUT_PROC ENDP
END MAIN