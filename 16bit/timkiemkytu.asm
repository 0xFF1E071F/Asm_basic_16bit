.model medium
.stack 100h
.data
msg db 13,10,' Cac file va so xau co trong file trong thu muc hien hanh:$'
msg1 db 13,10,'Khong tim thay.$'
endline db 13, 10, ' $'
filename db "*.*", 0
dta db 43 dup(0) 
msg2 db 13, 10, 13, 10, 'An phim bat ki de ket thuc...$'
msg3 db 'Nhap xau:', 13, 10, '$'
str db 30 dup(0) ;Ten xau nhap tu ban phim
next db 30 dup(0)
l1 dw 0 ;Do dai xau nhap tu ban phim
l2 dw 0 ;Kich thuoc (byte) cua file
dem dw 0
bodem db ?
handle dw ? ;The file
bodem2 db 0 ;Bo dem de chua du lieu doc tu file
.code
main proc
    mov ax, @data
    mov ds, ax 
    mov es, ax 
    call read
    xor cx,cx 
    lea dx, dta
    mov ah, 1ah
    int 21h 
    lea dx, filename 
    mov cx, 3fh ;Thuoc tinh de tim kiem tat ca cac file, thu muc
    mov ah, 4eh	;Tim file, thu muc dau tien
    int 21h 
    jc error ;Nhay neu co CF = 1
    mov ah, 9
    lea dx, msg
    int 21h
    mov ah, 2
    mov dx, 13
    int 21h
    mov dx, 10
    int 21h
while:
    mov ah, 4fh ;tim file, thu muc tiep theo
    int 21h
    jc finish	
    
    ;In ra ten file
    xor dx, dx
    lea dx, dta
    add dx, 1eh ;Chi den vung ten
    mov si, dx
    mov byte ptr [si + 13], '$' ;do dai cua ten file la 13
    mov ah, 3dh
    mov al, 0
    int 21h
    jc jump
    mov handle, ax ;Luu lai the file
    mov ah, 9
    int 21h
    call len_file
    call kmp
    call display
    mov ah, 2
    mov dx, 13
    int 21h
    mov dx, 10
    int 21h
    jump:  
    mov cx, 13  ;Xoa dta 
lap:
    mov [si], 0
    inc si
    loop lap
    mov cx, 3fh ;Tra lai gia tri 3fh cho cx
    jmp while ;Tiep tuc tim 

error:    
    mov ah, 9
    lea dx, msg1
    int 21h	

finish: 
    lea dx, msg2
    mov ah, 9
    int 21h 
    mov ah, 1
    int 21h 
    mov ah, 4ch
    int 21h     
main endp

read proc near ;Doc vao xau
    mov ah, 9
    lea dx, msg3
    int 21h 
    lea si, str
    xor bx, bx
    mov ah, 1
lap1:
    int 21h
    cmp al, 0dh
    je exit
    inc si ; Dua cac ki tu vao str tu str[1]
    mov byte ptr [si], al                  
    inc bx
    jmp lap1
exit:
    mov l1, bx
    inc si
    mov byte ptr [si], '$'
    ret   
read endp

len_file proc near ;Tinh kich thuoc file (luu vao l2)
    push ax
    push bx
    push cx
    push dx
    mov l2, 0
    mov bx, handle
    mov cx, 5
    lea dx, bodem2
    lap2: 
    mov ah, 3fh
    int 21h
    add l2, ax
    cmp ax, cx
    je lap2
    pop dx
    pop cx
    pop bx
    pop ax
    ret   
len_file endp

prekmp proc near ;Chuan bi cho thuat toan KMP
    push ax
    push bx
    push cx
    push dx
    push si
    mov ax, 1
    mov bx, 0
    lea si, next
    inc si
    mov [si], 0
whilepk:
    cmp ax, l1
    jg end_whilepk
whilepk1:
    xor cx, cx
    xor dx, dx
    cmp bx, 0
    jle end_whilepk1
    lea si, str
    add si, ax
    mov cx, [si]
    xor ch, ch
    lea si, str
    add si, bx
    mov dx, [si]
    xor dh, dh
    cmp cx, dx
    je end_whilepk1
    lea si, next
    add si, bx
    mov bx, [si]
    xor bh, bh
    jmp whilepk1
end_whilepk1:
    xor cx, cx
    xor dx, dx
    inc ax
    inc bx
    lea si, str
    add si, ax
    mov cx, [si]
    xor ch, ch
    lea si, str
    add si, bx
    mov dx, [si]
    xor dh, dh
    cmp cx, dx
    jne else
    lea si, next
    add si, bx
    mov dx, [si]
    xor dh, dh
    lea si, next
    add si, ax
    mov [si], dx
    jmp whilepk
else:
    lea si, next
    add si, ax
    mov [si], bx
    jmp whilepk
end_whilepk:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
prekmp endp

kmp proc near ;Thuat toan KMP
    push si
    mov dem, 0
    call prekmp
    mov ax, 1
    mov bx, 1
whilekmp:
    cmp bx, l2
    jg end_whilekmp
whilekmp1:
    cmp ax, 0
    jle end_whilekmp1
    lea si, str
    add si, ax
    mov cx, [si]
    xor ch, ch
    push ax
    push bx
    push cx
    mov ah, 42h ;Dich con tro file (tu dau file) 
    mov al, 0
    xor cx, cx
    mov dx, bx  ;(bx - 1) byte
    cmp dx, 0
    jne not_0   ;Neu bx = 0 thi khong dich
    dec dx
    not_0:
    mov bx, handle
    int 21h
    mov ah, 3fh ;Doc ki tu tai vi tri con tro file
    mov cx, 1
    lea dx, bodem
    int 21h
    lea si, bodem
    mov dx, [si]
    xor dh, dh
    pop cx
    pop bx
    pop ax
    cmp cx, dx
    je end_whilekmp1
    lea si, next
    add si, ax
    mov ax, [si]
    xor ah, ah
    jmp whilekmp1
end_whilekmp1:
    inc ax
    inc bx
    cmp ax, l1
    jle whilekmp
    lea si, next
    add si, ax
    mov ax, [si]
    xor ah, ah
    add dem, 1
    jmp whilekmp 
end_whilekmp:
    pop si
    ret
kmp endp 

display proc ;Hien thi mot o dang thap phan
    mov ax, dem
    xor cx, cx
    mov bx, 10
chia:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne chia
    mov ah, 2
hien_thi:
    pop dx
    or dl, 30h
    int 21h
    loop hien_thi
    ret
display endp

end main