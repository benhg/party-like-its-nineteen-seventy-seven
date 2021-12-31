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
getstr_with_print:
	ret


;; main_shell
;; The "main" loop of the OS
;; This is a simple shell which accepts commands and does things
;; based on those commands
main_shell:
	mov ax, 0h;
.shell_loop:
	mov si, shell_ps1 ;
	call putstr ;
	mov si, cmd_response;
	call getstr_with_print;
	mov ax, 0h ; For now, just loop once
	cmp ax, 0h;
	jne .shell_loop

	ret;
