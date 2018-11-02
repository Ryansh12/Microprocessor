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

choice: resb 2
value_1: resb 3
value_2: resb 3
b: resb 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data

msg: db "1.Successive Addition",0x0A
	db "2.Add and shift",0x0A
	db "3.Exit",0x0A 
len: equ $- msg

msg1: db "Enter the multiplier:",0x0A
len1: equ $-msg1

msg2: db "Enter the multiplicand:",0x0A
len2: equ $-msg2
enter: db 0x0A
len3: equ $-enter

a: dw 0
count: db 0
c: dw 0
p:dw 0
q:dw 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text

global main
main:
	print enter,1 
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
		read a,3
		call atoh_2
		mov bx,ax
		
		print msg2,len2
		read a,3
		call atoh_2
		

		 
		
		
		mov cx,00000

		u:
		add cx,ax
		dec bx
		jnz u
		mov ax,00
		mov ax,cx
		call htoa_4
		jmp main


case2:
		print msg1,len1
		read value_1,3
		mov bx,word[value_1]
		
		mov word[a],bx
		call atoh_2
		mov byte[value_1],al
		

		print msg2,len2
		read value_2,3
		mov bx,word[value_2]
		mov word[a],bx
		call atoh_2
		mov byte[value_2],al

		

		;;ADDING AND SHIFTING

		mov bl,byte[value_1]
		
		
		mov dl,byte[value_2]
		
		mov ax,0
		mov byte[count],08


	up1:
		shr bl,01
		jc next1
		shl dx,01
		jmp next2
	next1:
		add ax,dx
		shl dx,01
	next2:
		dec byte[count]
		jnz up1

		;;PRINTING MULTIPLIED NO.
		call htoa_4
		 
		jmp main




case3:
	;;exit

	mov rax,60
	mov rdi,0
	syscall


	;;THE NO IS SAVED IN A
	;;AND THE RESULT IN AL
	atoh_2:
	mov rdi,a
	mov ax,00
	mov byte[count],2
	up:
	rol ax,04
	mov cl,byte[rdi]
	cmp cl,39H
	jbe o
	sub cl,07
	o:
	sub cl,30H
	add al,cl
	inc rdi 
	dec byte[count]
	jnz up 
	ret


	;;PRINTING THE NO.
	htoa_2:
	mov rdi,b
	mov byte[count],2
	up2:
	rol al,04
	mov cl,al
	and cl,0FH
	cmp cl,30H
	jbe next
	add cl,07
	next:
	add cl,30H
	mov byte[rdi],cl
	inc rdi
	dec byte[count]
	jnz up2
	print b,2
	ret

htoa_4:
	mov rdi,b
	mov byte[count],4
	up4:
	rol ax,04
	mov cl,al
	and cl,0FH
	cmp cl,09H
	jbe next4
	add cl,07
	next4:
	add cl,30H
	mov byte[rdi],cl
	inc rdi
	dec byte[count]
	jnz up4
	print b,4
	ret

	


