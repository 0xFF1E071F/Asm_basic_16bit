.MODEL SMALL
.STACK 100H
.DATA

MSG DB 13, 10, 'INPUT:$'
MSG1 DB 13, 10, 'NOT FOUND$'
DTA DW 43 DUP(0)
LINK DW 30 DUP(0)
SIZE_LINK DW 30 DUP(0) 
SIZE_TENFOLDER DW 30 DUP(0)
TENFOLDER DW 30 DUP(0)

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX
    CALL NHAP_LINK
    CALL SEARCH
MAIN ENDP

SEARCH PROC                                  
    ;TIM KIEM
    XOR CX, CX
    LEA DX, DTA
    MOV AH, 1AH
    INT 21H
    
    LEA DX, LINK
    MOV CX, 3FH
    MOV AH, 4EH
    INT 21H
    JC ERROR 
    PUSH LINK
    PUSH DTA
    
    XOR DX, DX
    LEA DX, DTA
    ADD DX, 1EH
    MOV SI, DX
    MOV BYTE PTR [SI + 13], '$'
    
    LEA SI, DX
    LEA DI, TENFOLDER
    CLD
    MOV CX, 13
    REP MOVSB
    
    XOR DX, DX
    LEA DX, DTA
    ADD DX, 15H
    MOV SI, DX
    
    CMP [SI], 0
    JE FILE_S
    
    ;LINK = LINK + TENFOLDER
    PUSH LINK
    MOV BX, SIZE_LINK
    LEA SI, TENFOLDER
    LEA DI, LINK + BX
    CLD
    MOV CX, 13
    REP MOVSB
    
    ; Hien thi folder
    MOV AH, 9
    XOR DX, DX
    LEA DX, DTA
    ADD DX, 1EH
    MOV SI, DX
    MOV BYTE PTR [SI + 13], '$'
    INT 21H
    MOV CX, 13
    
LAP_S1:
    MOV [SI], 0
    INC SI
    LOOP LAP_S1
    MOV CX, 3FH
    
    CALL SEARCH
FILE_S:  

    ; Hien thi file
    MOV AH, 9
    XOR DX, DX
    LEA DX, DTA
    ADD DX, 1EH
    MOV SI, DX
    MOV BYTE PTR [SI + 13], '$'
    INT 21H
    MOV CX, 13
    
LAP_S2:
    MOV [SI], 0
    INC SI
    LOOP LAP_S2
    MOV CX, 3FH
    
    POP LINK
    
; TIM KIEM FILE KE TIEP    
WHILE_:
LAP_:
    MOV AH, 4FH
    INT 21H
    JC NOTFOUND
    
    XOR DX, DX
    LEA DX, DTA
    ADD DX, 15H
    MOV SI, DX
    
    CMP [SI], 0
    JE FILE_
    
    ;NEU GAP FOLDER
    ;LINK = LINK + TENFOLDER
    PUSH LINK
    MOV BX, SIZE_LINK
    LEA SI, TENFOLDER
    LEA DI, LINK + BX
    CLD
    MOV CX, SIZE_TENFOLDER
    REP MOVSB
    
    CALL SEARCH
    
    ;NEU GAP FILE
FILE_:
    ; Hien thi file
    MOV AH, 9
    XOR DX, DX
    LEA DX, DTA
    ADD DX, 1EH
    MOV SI, DX
    MOV BYTE PTR [SI + 13], '$'
    INT 21H
    MOV CX, 13
    
    LAP_S:
    MOV [SI], 0
    INC SI
    LOOP LAP_S
    MOV CX, 3FH
    
    JMP LAP_
    
NOTFOUND:
    ; TRUONG HOP KHONG TIM DUOC GI
    POP LINK
    POP DTA
    JMP LAP_
    
ERROR:
    MOV AH, 9
    LEA DX, MSG1
    INT 21H
FINISH:
    MOV AH, 4CH
    INT 21H
SEARCH ENDP

NHAP_LINK PROC                      
    ;NHAP LINK
    MOV AH, 9
    LEA DX, MSG
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
    MOV SIZE_LINK, BX
    MOV BYTE PTR [SI], '$'
    RET
NHAP_LINK ENDP

GET_NAME PROC
    
GET_NAME ENDP

END MAIN