; helloworld.asm

;Author : Taha Abdalzez
;Date : 7/12/2019

global _start

section .text:
_start:
	mov eax , 0x4    	 ;  for system call write
	mov ebx , 1     	 ;  use std as fd
	mov ecx , message	 ;  use message as a buffer
	mov edx , message_length ;  use message length as a counter
	int 0x80
	
	mov eax , 0x1		 ;  exit() syscall
	mov ebx , 0		 ;  the return value of the programe
	int 0x80 		 ;  intiate syscall

section .data:
	
	message: db "Hello world!", 0xA
	message_length equ $-message
