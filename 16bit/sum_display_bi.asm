; Cong tong 2 so co nhieu chu so hien thi tong duoi dang so nhi phan
.MODEL SMALL
.DATA
    MSG1 DB 'INPUT NUMBER 1: ', 13, 10, '$'
    MSG2 DB 13, 10, 'INPUT NUMBER 2: ', 13, 10, '$'
    MSG3 DB 13, 10, 'SUM: ', 13, 10, '$' 
.STACK 100H 
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ;NHAP NUM1
    MOV AH, 9
    LEA DX, MSG1
    INT 21H
    CALL INPUT_
    PUSH BX
    
    ;NHAP NUM2
	MOV AH, 9
	LEA DX, MSG2
	INT 21H
    CALL INPUT_
    MOV DX, BX      ;DX NUM2
	POP BX          ;BX NUM1
	
	;SUM
	ADD BX, DX
    MOV AH, 9
	LEA DX, MSG3
	INT 21H
		
    MOV AH, 2       ; Hien thi	
	MOV CL, 17 ; quay vong dich trai
WHILE_DISPLAY:
	SUB CL, 1
	CMP CL, 0
    JE FINISH_DISPLAY
	SHL BX, 1       ; Dich trai BX
    JNC CF_0        ; Nhay neu CF bang khong
    MOV DL, '1'
	INT 21H
	JMP WHILE_DISPLAY
CF_0:
	MOV DL, '0'
	INT 21H 
	JMP WHILE_DISPLAY
	
FINISH_DISPLAY: 
    MOV AH, 2
    MOV DX, 13
    INT 21H
    MOV DX, 10
    INT 21H
    MOV AH, 1
	INT 21H
	; Tro ve DOS
    MOV AH,4CH		
	INT 21H 		
MAIN ENDP
     	
INPUT_ PROC
    XOR BX, BX        
WHILE_2:
    MOV AH, 1
    INT 21H
    CMP AL, 13
    JE FINISH_2
    AND AL, 0001H
	XOR AH, AH      ; Reset gia tri 0 cho AH de thuc hien or bx voi ax
	SHL BX, 1
	OR BX, AX
    JMP WHILE_2        
FINISH_2:
        RET     	    
INPUT_ ENDP
     	
END MAIN