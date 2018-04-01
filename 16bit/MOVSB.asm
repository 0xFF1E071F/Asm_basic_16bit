TITLE TRAINNING: CHECKING
.MODEL SMALL
.STACK 100H
.DATA
STRING1 DB 'HELLO'
STRING2 DB 'XINCHAO'
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX
    MOV BX, 7
    LEA SI, STRING1
    LEA DI, STRING2+BX
    CLD
    MOV CX, 5    
    REP MOVSB
    
    mov ah, 1
    int 21h
    
    mov ah, 9
    lea dx, STRING2
    int 21h
    mov ah, 4ch
    int 21h
END MAIN
    