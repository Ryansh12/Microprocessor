section .bss

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro


%macro read 2
mov rax,0
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro


hexno: resb 5 
bcdno: resb 6
choice:resb 2
a: resb 5
b: resb 6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .data

msg: db 0x0A, "1.hex to BCD",0x0A
	db "2.BCD to hex",0x0A
	db "3.Exit",0x0A
len: equ $- msg

msg1: db "Enter hex no.",0x0A
len1: equ $- msg1

msg2: db "Enter BCD no.",0x0A
len2: equ $- msg2

msg3: db 0x0A
len3: equ $-msg

count: db 0
cnt: db 0
c:dw 0
k:dw 0
result2: dw 0
result:dw 0

section .text

global main
main:

	print msg,len
	read choice,2

	cmp byte[choice],31H
	je case1
	cmp byte[choice],32H
	je case2
	cmp byte[choice],33H
	je case3

case1:
	mov byte[count],0
	print msg1,len1
	read a,5

	call atoh_4
	
	mov ax,bx
	mov bx,0x0A

	up1:
	mov dx,00
	div bx
	push dx
	inc byte[count]
	cmp ax,0
	jnz up1
	;;PRINTING BCD
	
	up2:
	pop dx
	add dx,30H
	mov word[c],dx
	print c,2
	dec byte[count]
	jnz up2


jmp main





case2:
	mov word[result],0
	print msg2,len2
	read b,9
	call atoh_8 
	
	mov eax,00000000
	mov ax,cx
	and ax,0x000F
	mov bx,0x0001
	mul bx
	adc dword[result],eax


	ror ecx,04
	mov eax,0
	mov ax,cx
	and ax,0x000F
	mov bx,0x000A
	mul bx
	adc dword[result],eax
	

	ror ecx,04
	mov eax,0
	mov ax,cx
	and ax,0x000F
	mov bx,0x0064
	mul bx
	adc dword[result],eax
	

	ror ecx,04
	mov eax,0
	mov ax,cx
	and ax,0x000F
	mov bx,0x03E8
	mul bx
	adc dword[result],eax
	
	ror ecx,04
	mov eax,0
	mov ax,cx
	and ax,0x000F
	mov bx,0x2710
	mul bx
	adc dword[result],eax
	



	mov cx,word[result]
	call htoa_8
	
	


	jmp main



case3:

	mov rsi,60
	mov rdi,0
	syscall


atoh_4:
	mov bx,0
	mov rsi,a
	mov byte[cnt],4
	up_4:
	rol bx,4
	mov al,byte[rsi]
	cmp al,39H
	jbe next_4
	sub al,07
	next_4:
	sub al,30H
	add bl,al
	inc rsi
	dec byte[cnt]
	jnz up_4
	
	ret

atoh_8:
	mov ecx,0
	mov rsi,b
	mov byte[cnt],8
	up_8a:
	rol ecx,4
	mov bl,byte[rsi]
	cmp bl,39H
	jbe next_8a
	sub bl,07
	next_8a:
	sub bl,30H
	add cl,bl
	inc rsi
	dec byte[cnt]
	jnz up_8a
	ret

htoa_8:
	mov rdi,result
	mov byte[cnt],4
up_8:
	rol cx,04
	mov dl,cl
	and dl,0x0F
	cmp dl,09
	jbe next_8
	add dl,07
next_8:
	add dl,30H
	mov byte[rdi],dl
	inc rdi
	dec byte[cnt]
	jnz up_8
	print result,4
	ret







