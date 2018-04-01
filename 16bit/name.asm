TITLE HOTEN
.MODEL SMALL
.STACK 100H
.DATA
NUM1 DW 0
NUM2 DW 0
NUM3 DW 0
MSG DB 'Ban hay nhap vao 3 chu cai dau:$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    LEA DX, MSG
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    MOV NUM1, AX
    
    INT 21H
    MOV NUM2, AX
    
    INT 21H
    MOV NUM3, AX
    
    MOV AH, 2
    MOV DX, 13
    INT 21H
    MOV DX, 10
    INT 21H
    
    MOV DX, NUM1
    INT 21H
    MOV DX, 13
    INT 21H
    MOV DX, 10
    INT 21H
    
    MOV DX, NUM2
    INT 21H
    MOV DX, 13
    INT 21H
    MOV DX, 10
    INT 21H
    
    MOV DX, NUM3
    INT 21H 
    
    
END MAIN