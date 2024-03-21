[ORG 0x7c00]    ; Lo que hay debajo ponlo en la dirección 0x7c00
[BITS 16]

mov [MAIN_DISK], dl     ; proporcionado por la bios

; Codigo de arranque
mov bp, 0x1000  ; bp, puntero base de la pila
mov sp, bp

;mov ah, 0x0E
;mov al, 'H'
;int 0x10
mov bx, STRING
call print_string

; Configurar la lectura del disco
mov dl, [MAIN_DISK]
mov ah, 0X02    ; operación de lectura
mov al, 0X01    ; nº de sectores a leer
mov ch, 0X00    ; cilindro
mov dh, 0X00    ; cabezal
mov cl, 0X02    ; sector
mov bx, 0X8000  ; dirección a la que escribimos
; Llamar a la bios
int 0x13

call second_stage
mov ax, keyboardHandler
call install_keyboard

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

install_keyboard:
    push word 0
    pop ds
    cli

    ; Instalar el ISR del telado
    mov [4 * KEYBOARD_INTERRUPT], word keyboardHandler  ;sería [IVTR + 4 * KEYBOARD_INTERRUPT] pero ya sabemos que IVTR es 0 por convención del emulador
    mov [4 * KEYBOARD_INTERRUPT + 2], cs    ; code segment
    mov word [HANDLER], ax
    sti
    ret

keyboardHandler:
    pusha

    in al, 0x60     ; puerto estado PS2
    test al, 0x80   ;
    jnz .end
    
    mov bl, al
    xor bh, bh
    mov al, [cs:bx + keymap]
    cmp al, 13  ; comprobar si es 'Enter'. Si no lo es, imprimelo
    je .enter
    
    mov bl, [WORD_SIZE]
    mov [WRD + bx], al
    inc bx
    mov [WORD_SIZE], bl

    mov ah, 0x0e
    int 0x10

.end:
    mov al, 0x61    ; código "hemos terminado" para PS2
    out 0x20, al    ; puerto de control
    popa
    iret

.enter:
    mov bx, WRD
    call print_string
    jmp .end

WORD_SIZE: db 0
WRD: times 64 db 0
STRING: db "Hello World", 0
MAIN_DISK: db 0
KEYBOARD_INTERRUPT EQU 9
HANDLER: dw 0

keymap:
%include "keymap.inc"   ; macro de ensamblador

times 510-($-$$) db 0   ; nº de veces. 510 - (dir actual - inicio del programa), poner todo ceros
dw 0xaa55

second_stage:
    mov ah, 0x0e
    mov al, 'H'
    int 0x10
    ret

times 1024-($-$$) db 0   ; padding para añadir más cosas
