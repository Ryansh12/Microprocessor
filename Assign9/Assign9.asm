section .bss

%macro read 2
mov rax,0
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro


 b:resb 8
 count: resb 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .data

msg: db "Factorial is: "
len: equ $- msg


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
global main
main:

	pop rsi               ; will give no of arguments 
	pop rsi	              ; will give name of file in ASCII
	pop rsi               ; the no. whose factorial is to be calculated
	
	mov rax,0
	mov rax,1
	mov rbx,0
	mov bl,byte[rsi]
	
	sub bl,30H 
	
 	
 	factorial:
 		mul rbx
 		dec rbx
 		jnz no
 		 
 	ret
 	
 	no:
 	call factorial
 	
 	call htoa_8
 	jmp exit
 	
htoa_8:
	mov rdi,b
	mov byte[count],8
	up8:
	rol eax,04
	mov cl,al
	and cl,0FH
	cmp cl,09H
	jbe next8
	add cl,07
	next8:
	add cl,30H
	mov byte[rdi],cl
	inc rdi
	dec byte[count]
	jnz up8
	print b,8
	ret

	

exit:
	mov rax,60
	mov rdi,0
	syscall

;;OUTPUT

pratik@pratik-VirtualBox:~/MP/Assign9$ nasm -f elf64 Assign9.asm
pratik@pratik-VirtualBox:~/MP/Assign9$ ld -o Assign9 Assign9.o
ld: warning: cannot find entry symbol _start; defaulting to 00000000004000b0
pratik@pratik-VirtualBox:~/MP/Assign9$ ./Assign9 9
00058980


