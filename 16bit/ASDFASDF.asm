.MODEL SMALL
.STACK 100H
.DATA

MSG DB 13,10,' :$'
MSG1 DB 13,10,'Khong tim thay.$'
ENDLINE DB 13, 10, ' $'
FILENAME DB "C:\*.*", 0
DTA DB 43 DUP(0) 
MSG2 DB 13, 10, 13, 10, 'An phim bat ki de ket thuc...$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX 
    MOV ES, AX 

    XOR CX,CX 
    LEA DX, DTA
    MOV AH, 1AH
    INT 21H 
 
    LEA DX, FILENAME 
    MOV CX, 3FH ;Thuoc tinh de tim kiem tat ca cac file, thu muc
    MOV AH, 4EH	;Tim file, thu muc dau tien
    INT 21H 
    JC ERROR ;Nhay neu co duoc bat
    
    MOV AH, 9
    LEA DX, MSG
    INT 21H

WHILE:
    MOV AH, 4FH ;Tim file, thu muc tiep theo
    INT 21H    
    JC FINISH	
    
    ;In ra ten file
    MOV AH, 9
    LEA DX, ENDLINE
    INT 21H
    XOR DX, DX
    LEA DX, DTA
    ADD DX, 1EH ;Chi den vung ten
    MOV SI, DX
    MOV BYTE PTR [SI + 13], '$' ;Do dai cua ten file la 13
    INT 21H
      
    MOV CX, 13  ;Xoa DTA 
LAP:
    MOV [SI], 0
    INC SI
    LOOP LAP
    MOV CX, 3FH ;Tra lai gia tri 3FH cho CX
    
    JMP WHILE ;Tiep tuc tim 

ERROR:    
    MOV AH, 9
    LEA DX, MSG1
    INT 21H	

FINISH: 
    LEA DX, MSG2
    MOV AH, 9
    INT 21H 
    MOV AH, 1
    INT 21H 
    MOV AH, 4CH
    INT 21H 
    
MAIN ENDP
END MAIN
