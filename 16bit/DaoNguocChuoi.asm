TITLE reverse_input: REVERSE
.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'INPUT:', 13, 10, '$'
    MSG2 DB 13, 10, 'REVERSE: ', 13, 10, '$'
.CODE
MAIN PROC

; Hien thi msg1
    MOV AX, @DATA
    MOV DS, AX
    MOV AH, 9
    LEA DX, MSG1
	INT 21H
    XOR CX, CX
    MOV AH, 1

;Vong lap push du lieu vao stack
PUSH_:
    INT 21H
    CMP AL, 13
    JE END_PUSH
    PUSH AX
    INC CX
    JMP PUSH_
END_PUSH:

; Hien thi msg2
    MOV AH, 2
    MOV DL, 13
    INT 21H
    MOV DL, 10
    INT 21H
    MOV AH, 9
    LEA DX, MSG2
	INT 21H
	MOV AH, 2

; Vong lap pop du lieu tu stack ra hien thi theo thu tu nguoc lai
POP_:
    POP DX
    INT 21H
    LOOP POP_
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN