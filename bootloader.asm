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
        mov ah, BIOS_READ_SECTORS
        mov al, BIOS_INIT_SECTORS
        mov ch, BIOS_CYLINDER_IDX
        mov dh, BIOS_HEAD_IDX
        mov cl, BIOS_SECTOR_IDX
        mov dl, BIOS_DISK_IDX
        mov bx, post ; address of more than 512 bytes
        int INTR_SET_DISK ; send interrupt to say apply disk settings set above

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