.MODEL SMALL
.STACK 100H
.DATA

MSG DB 13, 10, 'TIM THAY:', 13, 10, '$'
MSG1 DB 13, 10, 'KHONG TIM THAY$'
MSG2 DB 13, 10, 'NHAP VAO LINK:', 13, 10, '$'
LINK DB 30 DUP(0)
11 DW 0
ENTER DB 13, 10, ' $'
DTA DB 43 DUP(0)

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX 
    MOV ES, AX
; Nhap LINK    
    CALL NHAP_LINK
    
    LEA DX, LINK
    MOV AH, 9
    INT 21H 
    
    XOR CX,CX 
    LEA DX, DTA
    MOV AH, 1AH
    INT 21H 
 
    LEA DX, LINK 
    MOV CX, 3FH
    MOV AH, 4EH
    INT 21H 
    JC ERROR
    
    MOV AH, 9
    LEA DX, MSG
    INT 21H
    
    XOR DX, DX
    LEA DX, DTA
    ADD DX, 1EH
    MOV SI, DX
    MOV [SI + 13], '$'
    INT 21H

WHILE:
    MOV AH, 4FH
    INT 21H    
    JC FINISH	
    
    MOV AH, 9
    LEA DX, ENTER
    INT 21H
    XOR DX, DX
    LEA DX, DTA
    ADD DX, 1EH
    MOV SI, DX
    MOV [SI + 13], '$'
    INT 21H
      
    MOV CX, 13 
LAP:
    MOV [SI], 0
    INC SI
    LOOP LAP
    MOV CX, 3FH
    
    JMP WHILE 

ERROR:    
    MOV AH, 9
    LEA DX, MSG1
    INT 21H	

FINISH: 
    MOV AH, 1
    INT 21H 
    MOV AH, 4CH
    INT 21H 
    
MAIN ENDP

NHAP_LINK PROC
    MOV AH, 9
    LEA DX, MSG2
    INT 21H
    LEA SI, LINK
    XOR BX, BX
    MOV AH, 1
LOOP_:
    INT 21H
    CMP AL, 13
    JE EXIT_
    MOV BYTE PTR [SI], AL
    INC SI
    INC BX
    JMP LOOP_
EXIT_:
    MOV BYTE PTR [SI], '$'
    RET
NHAP_LINK ENDP
END MAIN