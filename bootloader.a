        bits 16

boot:                                  ; Label for main program
        cli
        mov ax, 07c0h                  ; 4k stack
        add ax, 288                    ; 4k stack + 512 boot / 16
        mov ss, ax                     ; put the val of ax into the stack segment

        mov ax, 07c0h                  ; Move data segment to current location
        mov ds, ax                     ; put the ax address into data seg

        mov si, msg                    ; point source index at our message (declared later)
        call putstr                    ; The putstr routine prints a null-terminated string from si

        ;; do stuff

        mov si, gb_msg				   ; time to say goodbye
        call putstr

        hlt                            ; once we get here, halt


%include "boot_data.a"
%include "io_lib.a"

;; Set up the magic numbers
times 510 - ($ - $$) db 0 ; write zeroes into b0-510
dw 0xAA55 ; AA55 is the magic number for 511 and 512
