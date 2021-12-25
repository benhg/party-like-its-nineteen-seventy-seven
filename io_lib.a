;; io_lib.a
;; This file is where we keep IO library
;;

%include "bios_defines.ah"

;; putstr: Print a NUL-terminated string that is pointed to by si

putstr:
        mov ah, 0xE                    ; 0xE / eh tells BIOS putchar

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
mov ah, 0xE  ; Get ready to putchar

.loop2:
    lodsb ; Load SI into AL, increment SI
    cmp al, 0 ; If we're at the end of the string, we want to end
    je .ret ;
    cmp al, 1 ; '1' is the reserved string used as a format
    je .insert_format ;
    ; .insert_format doesn't put the char, just sets it up to be put
    int INTR_PUTCHAR               ;
    jmp .loop2            ;

.insert_format:
    mov al, [ebx] ; Move val pointed at by ebx into al
    inc ah ; Increment ah now that we're done with this
    ret;

.ret:
    ret