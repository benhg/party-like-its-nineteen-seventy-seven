;; io_lib.a
;; This file is where we keep IO library
;;

%include "bios_defines.ah"

;; putstr: Print a NUL-terminated string that is pointed to by si

putstr:
        mov ah, BIOS_PUTCHAR  ; Tell the bios we're going to putchar by putting e into ah
                              ; therefore, when we do the interrupt, BIOS reads char out of al and prints it.

.loop1:
	lodsb                          ; Load value pointed at by SI into AL and increment SI
        cmp al, 0                      ; If the AL is empty, we hit end of string
        je .halt                       ; Jump to our halt (just runs ret instruction)end ot string
        int INTR_PUTCHAR               ;
        jmp .loop1                     ; jump back to .loop tag
.halt:
        ret                            ; Define a command to halt so that we can jump to it


;; printf: Print a formatted NUL-term string.
;; Point at format-encoded string literal with SI
;; Point at list of format args with ah
;; For now, format args can only be one byte
printf:
mov ah, BIOS_PUTCHAR  ; Get ready to putchar

.loop2:
    lodsb ; Load SI into AL, increment SI
    cmp al, 0 ; If we're at the end of the string, we want to end
    je .ret ;

    cmp al, ASCII_1 ; '1' is the reserved string use as a format
    je .insert_format ;
    ; .insert_format doesn't put the char, just puts in al and increments ebx
.printf_putchar:
    int INTR_PUTCHAR               ;
    jmp .loop2           ;

.ret:
    
    ret

.insert_format:
    mov al, [ebx] ; Move val pointed at by ebx into al
    inc ebx ; Increment ebx now that we're done with this
    jmp .printf_putchar;