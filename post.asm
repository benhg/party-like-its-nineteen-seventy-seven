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

    ;; test getchar
    mov si, getchar_tst_msg ;
    call putstr
    mov ebx, getchar_test_save_loc
    call getchar
    mov ebx, getchar_test_save_loc
    mov si, getchar_res_msg
    call printf
    mov ebx, 0h;

    mov si, post_end_msg ;
    mov ebx, post_success_data ;
    call printf;
    ret
