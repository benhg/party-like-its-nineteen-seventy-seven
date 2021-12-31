;;
;; shell.asm
;; This file maintains the main OS shell loop and related routines

%include "shell_data.ah"

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


;; main_shell
;; The "main" loop of the OS
;; This is a simple shell which accepts commands and does things
;; based on those commands
main_shell:
	mov ax, 0h;
.shell_loop:
	mov si, shell_ps1 ;
	call putstr ;
	mov ebx, cmd_response;
	mov cx, STRING_SIZE;
	call getstr_with_print;
	mov si, newline_return; advance the line
	call putstr;
	mov ebx, cmd_response;
	mov al, [ebx] ;
	cmp al, ASCII_Q;
	je .shell_quit
	mov si, cmd_err_msg;
	call putstr;
	jmp .shell_loop


.shell_quit:
	mov si, shell_quit_msg;
	call putstr
	ret;
