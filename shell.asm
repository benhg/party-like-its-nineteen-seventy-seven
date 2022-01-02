;;
;; shell.asm
;; This file maintains the main OS shell loop and related routines

%include "shell_data.ah"

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
