bits 16

[org 0x7c00]

%include "bios_defines.ah"
%include "type_defines.ah"

boot:   ; Label for main program
        ; stack and segment setup
        xor ax, ax
        mov es, ax
        mov ds, ax
        mov bp, STACK_START_ADDR
        mov ss, ax      ; put the val of ax into the stack segment
        mov sp, bp
        ; load more than 512 bytes into memory
        mov ah, 0x02    ; read sectors
        mov al, 0x01    ; sectors to read
        mov ch, 0x00    ; cylinder idx
        mov dh, 0x00    ; head idx
        mov cl, 0x02    ; sector idx
        mov dl, 0x00    ; disk idx
        mov bx, post ; address of more than 512 bytes
        int 0x13

        mov si, msg                    ; point source index at our message (declared later)
        call putstr                    ; The putstr routine prints a null-terminated string from si

        call post

        ;;call main_shell

        mov si, gb_msg			; time to say goodbye
        call putstr

        hlt                            ; once we get here, halt


%include "boot_data.ah"
%include "io_lib.asm"

;; Set up the magic numbers
times 510 - ($ - $$) db 0 ; write zeroes into b0-510
dw 0xAA55 ; AA55 is the magic number for 511 and 512

%include "post.asm"
%include "shell.asm"

; amount of zeros = 512 + (number of sectors read * 512)
times 1024-($-$$) db 0