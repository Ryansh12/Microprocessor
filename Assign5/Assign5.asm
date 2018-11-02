section .bss

global buffer,descriptor,buf_len,char

buffer: resb 2000
descriptor: resb 4                           ; instead of fd_in

choice: resb 2

char:resb 2

buf_len: resb 4




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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .data

global msg1,len1,msg2,len2,msg3,len3

fname: db 'abc.txt',0         ; As filename ends with '\0' byte

msg: db "1.No. of spaces",0x0A
	db "2.No. of lines",0x0A
	db "3.No. of character(a)",0x0A
	db "4.Exit",0x0A
len: equ $- msg

msg1: db "No of spaces are:"
len1: equ $- msg1

msg2: db "No of lines are:"
len2: equ $- msg2

msg3: db "Enter the character: "
len3: equ $- msg3

msg4: db "File successfully opened",0x0A
len4: equ $- msg4

msg5: db "File unsuccessfully opened",0x0A
len5: equ $- msg5

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
global main
main:
extern spc,ent,chr

;;OPENING THE FILE

	mov rax,2             ; 2 to open file
	mov rdi,fname	      ; filename
	mov rsi,2	      ; 2 for read/write
	mov rdx,0777          ; all permissions given
	syscall               ; open file for read/write

	bt rax,63
	jc fail
	

;;READING THE FILE

	mov [descriptor],rax  ; storing the descriptor

	mov rax,0	      ; read from file
	mov rdi,[descriptor]  ; the file descriptor
	mov rsi,buffer        ; read to buffer
	mov rdx,2000          ; read 2000 bytes
	syscall               ; read 2000 bytes to buffer from file

	mov [buf_len],rax

	print msg4,len4

;;WRITING THE FILE TO TERMINAL


 	mov rax,1             ; write the file
 	mov rdi,1	      ; to terminal
 	mov rsi,buffer        ; from buffer
 	mov rdx,[buf_len]     ; of 2000 bytes
 	syscall		      ; write to terminal 2000 bytes from buffer

srt:
 	print msg,len
	read choice,2

	cmp byte[choice],31H
	je case1
	cmp byte[choice],32H
	je case2
	cmp byte[choice],33H
	je case3
	cmp byte[choice],34H
	je case4

	case1:
	print msg1,len1
	call spc
	jmp srt

	case2:
	print msg2,len2
	call ent
	jmp srt

	case3:
	print msg3,len3
	read char,2
	call chr
	jmp srt

	case4:

;;CLOSING THE FILE

	mov rax,3	      ; 3 to close file
	mov rdi,[descriptor]  ; the file descriptor
	syscall
	jmp exit

	fail:
	print msg5,len5
	
	exit:
	mov rax,60
	mov rdi,0
	syscall
	



;;OUTPUT
pratik@pratik-VirtualBox:~/MP/Assign5$ nasm -f elf64 Assign5.asm
pratik@pratik-VirtualBox:~/MP/Assign5$ nasm -f elf64 procedures.asm
pratik@pratik-VirtualBox:~/MP/Assign5$ ld -o Assign5 Assign5.o procedures.o
ld: warning: cannot find entry symbol _start; defaulting to 00000000004000b0
pratik@pratik-VirtualBox:~/MP/Assign5$ ./Assign5
File successfully opened
fsghahx gvsaxgasxcga
ahsxcvjavca hbsjsc
1.No. of spaces
2.No. of lines
3.No. of character(a)
4.Exit
1
No of spaces are:02
1.No. of spaces
2.No. of lines
3.No. of character(a)
4.Exit
2
No of lines are:02
1.No. of spaces
2.No. of lines
3.No. of character(a)
4.Exit
3
Enter the character: a
07
1.No. of spaces
2.No. of lines
3.No. of character(a)
4.Exit
4


