section .bss
extern buffer,descriptor,buf_len,char

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






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data

enter: db 0x0A
lenn: equ $-enter



extern msg1,len1,msg2,len2,msg3,len3
no: db 0
a: dw 0
count: db 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text

global main2

main2:

global spc,ent,chr
	spc:
	mov rcx, qword[buf_len]
	 mov qword[count],rcx

	 mov rsi,buffer
	up1:
	 cmp byte[rsi],20H
	 je next1
	 inc rsi
	 dec byte[count]
	 jnz up1
	 jmp next11
	 next1:
	 inc byte[a]
	 inc rsi
	 dec byte[count]
	 jnz up1
	 next11:

	 call htoa_2
	 print enter,lenn
	ret


	ent:
	mov byte[a],0
	 mov rcx, qword[buf_len]
	 mov qword[count],rcx

	 mov rsi,buffer
	up2:
	 cmp byte[rsi],0x0A
	 je next2
	 inc rsi
	 dec byte[count]
	 jnz up2
	 jmp next22
	 next2:
	 inc byte[a]
	 inc rsi
	 dec byte[count]
	 jnz up2
	 next22:

	 call htoa_2
	 print enter,lenn
	ret

	chr:
	
	mov byte[a],0
	 mov rcx, qword[buf_len]
	 mov qword[count],rcx
	 mov al,byte[char]
	 mov rsi,buffer
	 up3:
	 cmp byte[rsi],al
	 je next3
	 inc rsi
	 dec byte[count]
	 jnz up3
	 jmp next33
	 next3:
	 inc byte[a]
	 inc rsi
	 dec byte[count]
	 jnz up3
	 next33:

	 call htoa_2
	 print enter,lenn
	ret

htoa_2:
	mov cl,byte[a]
	mov rdi,no
	mov byte[count],2
up_2:
	rol cl,04
	mov dl,cl
	and dl,0x0F
	cmp dl,09
	jbe next_2
	add dl,07
next_2:
	add dl,30H
	mov byte[rdi],dl
	inc rdi
	dec byte[count]
	jnz up_2
	print no,2
	ret









;;EXIT
	mov rax,60
	mov rdi,0
	syscall
