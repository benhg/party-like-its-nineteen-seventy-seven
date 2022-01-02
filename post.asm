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

    ;; test getstr
    mov si, getstr_tst_msg
    call putstr ;
    mov ebx, getstr_test_loc
    mov cx, POST_GETSTR_SZ
    call getstr_with_print;
    mov si, newline_return; advance the lin
    call putstr;
    mov si, getstr_tst_rslt_msg;
    call putstr;
    mov si, getstr_test_loc
    call putstr;
    mov si, newline_return;
    call putstr;


    ;; print end msgs
    mov si, post_end_msg ;
    mov ebx, post_success_data ;
    call printf;
    ret
