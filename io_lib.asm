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

;; getchar: Get a character from the screen 
;; and put it into address pointed to by ebx
;; DOES NOT increment ebx
getchar:
    mov ah, 0h
    int INTR_GETCHAR ;; This puts the char into al reg
    mov [ebx], al ;; copy the character over to ecx's pointee
    ret

;; getstr
;; Get a string. Keep listening for more keystrokes until
;; a) string ends (we assume strings will be terminated with `/`)
;; b) string is too big (caller should pass in a maximum size thru cx)
;; Caller should put an address for storing the string in ebx
;; Program will put the string in the location specified by ebx
;; Program will return length of passed-in string in dx
getstr:
    mov dx, 0;
.loop_getstr:
    call getchar
    inc dx
    inc ebx ; getchar does NOT increment address of string
    cmp al, ASCII_SLASH
    je .halt_getstr
    cmp dx, cx ; if dx (string count) bigger than cx (max passed by user)
    jge .halt_getstr
    jmp .loop_getstr

.halt_getstr:
    mov ax, 0h;
    ret;


;; getstr_with_print
;; getstr, but when a character is read into memory
;; print it to the console
;; Useful for the shell - want users to see commands they type
;; Caller should put an address for storing the string in ebx
;; Program will put the string in the location specified by ebx
;; Program will return length of passed-in string in dx
;; Caller should put max size of string in cx
getstr_with_print:
    mov dx, 0;
.s_loop_getstr:
    call getchar
    mov ah, BIOS_PUTCHAR; Print back the character right after we get it
    int INTR_PUTCHAR
    mov ah, 0h; clean out ah
    inc dx
    inc ebx ; getchar does NOT increment address of string
    cmp al, ASCII_SLASH
    je .s_halt_getstr
    cmp dx, cx ; if dx (string count) bigger than cx (max passed by user)
    jge .s_halt_getstr
    jmp .s_loop_getstr

.s_halt_getstr:
    mov ax, 0h;
    ret;
