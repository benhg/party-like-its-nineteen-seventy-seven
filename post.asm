;;
;; post.asm
;; This file maintains Power-On Self Test routines

;; power-on self test
post:
    mov si, post_start_msg
    call putstr

    ;; test printf
    mov si, printf_test ;
    mov ebx, printf_data;
    call printf ;

    mov si, post_end_msg ;
    mov ebx, post_printf_data ;
    call printf;
    ret
