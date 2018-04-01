TITLE ASM: HIEN THI KY TU
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'NHAP KY TU:', 13, 10, '$'
MSG2 DB 13, 10, 'KY TU VUA NHAP:', 13, 10, '$'
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    MOV BL, AL
    
    
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    
    MOV AH, 2
    MOV DL, BL
    INT 21H
    
    MOV DL, 13
    INT 21H
    
    MOV DL, 10
    INT 21H
    
    MOV DL, AL
    INT 21H
END MAIN
    