[ORG 0x7c00]    ; Lo que hay debajo ponlo en la dirección 0x7c00
[BITS 16]

; Codigo de arranque
mov bp, 0x1000  ; bp, puntero base de la pila
mov sp, bp

;mov ah, 0x0E
;mov al, 'H'
;int 0x10
mov bx, STRING
call print_string

jmp $ ; saltar a la direccion actual. Ejecuta esta instruccion continuamente

;bx direccion del string
print_string:
    pusha
    xor si, si  ; pone a cero un registro
.loop:
    mov al, byte[bx + si]
    inc si
    cmp al, 0
    je .end
    call print_char
    jmp .loop
.end:
    popa
    ret

print_char:
    push ax
    mov ah, 0x0E    ; parámetro para int 0x10. Caracteres TTY
    int 0x10        ; interrupción del sistema para servicios de video
    pop ax
    ret

STRING: db "Hello World", 0

times 510-($-$$) db 0   ; nº de veces. 510 - (dir actual - inicio del programa), poner todo ceros
dw 0xaa55