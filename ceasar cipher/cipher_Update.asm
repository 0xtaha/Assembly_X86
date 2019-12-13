segment .rodata
    help db 0xa,'USAGE:', 0xa, './caesar "[ MESSAGE ]"', 0xa
    lhelp equ $ - help

    rot db 'Enter the ROT letter A = '
    lrot equ $ - rot
    
    error db 'please enter a lower lettercase',0xa
    lerror equ $ - equ error

    shift dp 'shift = '
    lshift equ $ - equ shift

    break db 0xa
    lbreak equ $ - break

segment .data
    rot_value db 00
    sh        db 00

segment .bss
    cript resb 0x400

section .text

    global _start:
_start:
    cmp byte [esp], 0x01
    je _usage

    ;; GETTING THE PARAM STRING
    mov eax, [esp+0x08]     ; get the string
    mov esi, eax

    ;; SHOW THE MESSAGE TO ENTER THE ROT NUMBER
    push lrot
    push rot
    call _print

    ;; ENTER A DIGIT
    mov edx, 0x04
    mov ecx, rot_value
    mov ebx, 0x00               ; stdin
    mov eax, 0x03               ; read()
    int 0x80

    mov edx, rot_value         ; store in edx

    cmp edx, 'z';
    jg _error;
    cmp edx, 'a';
    jl _error;
    
    sub edx, 97
    mov rot_value , edx 

    push lshift
    push shift
    call _print
    
    push 0x08
    push rot_value
    call _print

    

    _error:
	push lerror
	push error
	call _print
	call _end
	
    ;; MOVING TO EAX THE STRING
    mov eax, esi

    ;; GET THE SIZE OF PARAM STRING
    call _getsize


    ;; ENCRIPT THE STRING
    mov esi, ebx                ; mov to esi the len of the string
    xor ebx, ebx                ; clear ebx
    call _encript               ; encript the string

    jmp end                     ; end


_getsize:
    cmp byte [eax+ebx], 0x00    ; compare the char with null
    jne _lgs                    ; if not null -> jmp _lgs
    ret                         ; ret

    _lgs:
        inc ebx                 ; increment ebx
        jmp _getsize            ; check the next char jumping to _getsize

_encript:
    cmp ebx, esi                ; compare ebx == length of string
    jne _lenc                   ; if not equal -> rot
    inc ebx                     ; increment bx
    mov byte[cript+ebx], 0x00   ; empty cript variable

    push esi
    push cript

    call _print                 ; print the string

    push lbreak
    push break
    call _print                 ; break the line

    jmp end

    _lenc:                      ; encript loop
        
        mov cl, [eax+ebx]



        cmp cl, ' '
        jne _rot


        mov [cript+ebx], ecx

        inc ebx
        jmp _encript

    _rot:                       ; non space character
        add cl, [edx]
        sub cl, '0'

        cmp cl, 'z'
        jg _gt

        mov [cript+ebx], ecx

        inc ebx
        jmp _encript

    _gt:                        ; greater than 26 (z)
        sub cl, 26

        mov [cript+ebx], ecx

        inc ebx
        jmp _encript


_usage:
    push lhelp
    push help

    call _print

    jmp end


_print:
    mov edx, [esp+0x08]
    mov ecx, [esp+0x04]
    mov ebx, 0x01
    mov eax, 0x04
    int 0x80

    ret


end:
    mov eax, 0x01
    xor ebx, ebx
    int 0x80
