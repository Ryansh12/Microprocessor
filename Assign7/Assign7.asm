section .bss

global buffer,descriptor,buf_len,char

buffer: resb 2000
descriptor: resb 4                           ; instead of fd_in

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .data



fname: db 'bubble.txt',0         

msg:    db "1.Acsending Order",0x0A
	db "2.Descending Order",0x0A
	db "3.Exit",0x0A
len: equ $- msg

msg1: db "Ascending Order is: "
len1: equ $- msg1

msg2: db "Descending Order is: "
len2: equ $- msg2


msg4: db "File successfully opened",0x0A
len4: equ $- msg4

msg5: db "File unsuccessfully opened",0x0A
len5: equ $- msg5

count1: db 0
count2: db 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
global main
main:


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
 	mov rdx,[buf_len]         ; of 2000 bytes
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
	

	case1:
	print msg1,len1
	call asc
	jmp srt

	case2:
	print msg2,len2
	call des
	jmp srt

	

	
	
	case3:

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

asc:
 	mov byte[count1],5
 	up2:
 	mov byte[count2],4
 	mov rsi,buffer
 	mov rdi,buffer+2    
 	up: 
 	
 	mov al,byte[rdi]
 	cmp byte[rsi],al
 	jbe ne
 	mov al,byte[rsi]
 	mov bl,byte[rdi]
 	mov byte[rsi],bl
 	mov byte[rdi],al
 	    	
 	    	
 	    	
 	ne:
 	add rsi,2
 	add rdi,2
 	dec byte[count2]
 	jnz up
 	dec byte[count1]
 	    	
 	jnz up2
 	    	   
 	    	
 	    	
 	mov rax,1            
 	mov rdi,[descriptor]	    
 	mov rsi,buffer       
 	mov rdx,qword[buf_len]      
 	syscall		     
	
	ret

des:
	mov byte[count1],5
 	up22:
 	mov byte[count2],4
 	mov rsi,buffer
 	mov rdi,buffer+2    
 	up1: 
 	
 	mov al,byte[rdi]
 	cmp byte[rsi],al
 	ja ne1
 	mov al,byte[rsi]
 	mov bl,byte[rdi]
 	mov byte[rsi],bl
 	mov byte[rdi],al
 	    	
 	    	
 	    	
 	ne1:
 	add rsi,2
 	add rdi,2
 	dec byte[count2]
 	jnz up1
 	dec byte[count1]
 	    	
 	jnz up22
 	    	   
 	    	
 	    	
 	mov rax,1            
 	mov rdi,[descriptor]	    
 	mov rsi,buffer       
 	mov rdx,qword[buf_len]      
 	syscall		     
	
	ret



