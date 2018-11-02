section .bss

global buffer,descriptor,buf_len,char

buffer: resb 2000
descriptor: resb 4                           ; instead of fd_in
descriptor2: resb 4
descriptor3: resb 4
choice: resb 2


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


fname1: resb 10  
fname2: resb 10     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .data



 

msg:    db "1.Type",0x0A
	db "2.Copy",0x0A
	db "3.Delete",0x0A
	db "4.Exit",0x0A
len: equ $- msg




msg4: db "File successfully opened",0x0A
len4: equ $- msg4

msg5: db "File unsuccessfully opened",0x0A
len5: equ $- msg5



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
global main
main:

	pop rsi               ; will give no of arguments 

	pop rsi	              ; will give name of file in ASCII
	
	
	pop rsi                       ; gives operation to be perfomed(t,c,d)
	
	cmp byte[rsi],'t'
	je case1
	cmp byte[rsi],'c'
	je case2
	cmp byte[rsi],'d'
	je case3

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	case1:
	
	pop rsi
	
	mov rdi,fname1
	up:
	mov al,byte[rsi]
	mov byte[rdi],al
	cmp byte[rsi],0
	jz below
	inc rsi
	inc rdi
	jmp up
	below:
	
	;;OPENING THE FILE1

	mov rax,2             ; 2 to open file
	mov rdi,fname1	      ; filename
	mov rsi,2	      ; 2 for read/write
	mov rdx,0777          ; all permissions given
	syscall               ; open file for read/write

	bt rax,63
	jc fail
	

	;;READING THE FILE1

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
 	
 	;;CLOSING THE FILE1

	mov rax,3	      ; 3 to close file
	mov rdi,[descriptor]  ; the file descriptor
	syscall
	
 	jmp case4           ; EXIT
 
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	case2:
	
	pop rsi
	
	mov rdi,fname1
	up1:
	mov al,byte[rsi]
	mov byte[rdi],al
	cmp byte[rsi],0
	jz below1
	inc rsi
	inc rdi
	jmp up1
	below1:
	
	pop rsi
	mov rdi,fname2
	up2:
	mov al,byte[rsi]
	mov byte[rdi],al
	cmp byte[rsi],0
	jz below2
	inc rsi
	inc rdi
	jmp up2
	
	below2:
	;;OPENING THE FILE1

	mov rax,2             ; 2 to open file
	mov rdi,fname1	      ; filename
	mov rsi,2	      ; 2 for read/write
	mov rdx,0777          ; all permissions given
	syscall               ; open file for read/write

	bt rax,63
	jc fail
	

	;;READING THE FILE1

	mov [descriptor],rax  ; storing the descriptor

	mov rax,0	      ; read from file
	mov rdi,[descriptor]  ; the file descriptor
	mov rsi,buffer        ; read to buffer
	mov rdx,2000          ; read 2000 bytes
	syscall               ; read 2000 bytes to buffer from file

	mov [buf_len],rax

	print msg4,len4
	
	
	;;OPENING THE FILE2

	mov rax,2             ; 2 to open file
	mov rdi,fname2	      ; filename
	mov rsi,2	      ; 2 for read/write
	mov rdx,0777          ; all permissions given
	syscall               ; open file for read/write

	bt rax,63
	jc fail
	

	

	mov [descriptor2],rax  ; storing the descriptor
	
	
	
	;;WRITE TO FILE2 FROM BUFFER OF FILE1
	
	mov rax,1            
 	mov rdi,[descriptor2]	    
 	mov rsi,buffer       
 	mov rdx,qword[buf_len]      
 	syscall	
 	
	
	;;CLOSING THE FILE2

	mov rax,3	       ; 3 to close file
	mov rdi,[descriptor2]  ; the file descriptor
	syscall
	
	;;CLOSING THE FILE1

	mov rax,3	      ; 3 to close file
	mov rdi,[descriptor]  ; the file descriptor
	syscall
	
	jmp case4           ; EXIT           

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	case3:
	
	pop rsi
	
	mov rdi,fname1
	up3:
	mov al,byte[rsi]
	mov byte[rdi],al
	cmp byte[rsi],0
	jz below3
	inc rsi
	inc rdi
	jmp up3
	below3:
	
	;;TO DELETE THE FILE3	
	mov rax,87                   ;;to unlink[delete] the file3
	mov rdi,fname1               ;; in fname1 file3.txt stored
	syscall
	
	
	jmp case4           ; EXIT
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	case4:
	
	jmp exit
	fail:
	print msg5,len5
	
	exit:
	mov rax,60
	mov rdi,0
	syscall

;;OUTPUT
pratik@pratik-VirtualBox:~/MP/Assign8$ nasm -f elf64 Assign8.asm
pratik@pratik-VirtualBox:~/MP/Assign8$ ld -o Assign8 Assign8.o
ld: warning: cannot find entry symbol _start; defaulting to 00000000004000b0
pratik@pratik-VirtualBox:~/MP/Assign8$ ./Assign8 type file1.txt
File successfully opened
nasm -f elf64 Assign8.asm
ld -o Assign8 Assign8.o

for type:
./Assign8  type file1.txt

for copy:
./Assign8  copy file1.txt  file2.txt 

for delete:
./Assign8  delete file3.txt  
ls                               ;;to verify file is deleted or not

pratik@pratik-VirtualBox:~/MP/Assign8$ ./Assign8 copy file1.txt file2.txt
File successfully opened
pratik@pratik-VirtualBox:~/MP/Assign8$ ./Assign8 deleted file3.txt



