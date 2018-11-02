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


m: resb 4
g: resb 6
l: resb 2
i: resb 6
t: resb 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data

msg1: db 0x0A,"In protcted mode"
len1: equ $-msg1

msg2: db 0x0A,"Content of MSW: "
len2: equ $-msg2

msg3: db 0x0A,"Content of GDTR: "
len3: equ $-msg3

msg4: db 0x0A,"Content of LDTR: "
len4: equ $-msg4

msg5: db 0x0A,"Content of IDTR: "
len5: equ $-msg5

msg6: db 0x0A,"Content of TR: "
len6: equ $-msg6

msg7: db  0x0A,"Limit:"
len7: equ $-msg7

msg8: db " Offset:"
len8: equ $-msg8

enter: db 0x0A
len:equ $- enter

count: db 0
b: dw 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text
	
		
	print msg2,len2
	smsw eax            ;;;;;;;;;NOT MEM LOCATION
	mov dword[m],eax
		mov rsi,m+2
	

	mov eax,0
	mov ax,word[rsi]
	call htoa
	mov rsi,m
	mov eax,0
	mov ax,word[rsi]
	call htoa
	



	print msg4,len4
	sldt [l]
	mov ax,word[l]
	call htoa
	
	

	print msg3,len3
	sgdt [g]
	print msg7,len7
	mov rsi,g+4
	mov ax,word[rsi]
	call htoa
	print msg8,len8
	mov rsi,g+2
	mov ax,word[rsi]
	call htoa
	mov rsi,g
	mov ax,word[rsi]
	call htoa

	

	print msg5,len5
	sidt [i]
	
	mov rsi,i+4
	mov ax,word[rsi]
	call htoa
	
	mov rsi,i+2
	mov ax,word[rsi]
	call htoa
	mov rsi,i
	mov ax,word[rsi]
	call htoa

	print msg6,len6
	str [t]
	mov ax,word[t]
	call htoa


	print enter,len
	mov rax,60
	mov rdi,0
	syscall

htoa:
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


;;OUTPUT
pratik@pratik-VirtualBox:~/MP/Assign6$ nasm -f elf64 Assign6.asm
pratik@pratik-VirtualBox:~/MP/Assign6$ ld -o Assign6 Assign6.o
ld: warning: cannot find entry symbol _start; defaulting to 00000000004000b0
pratik@pratik-VirtualBox:~/MP/Assign6$ ./Assign6

Content of MSW: 80050035
Content of LDTR: 0000
Content of GDTR: 
Limit:7FD0 Offset:9000007F
Content of IDTR: FF5780000FFF
Content of TR: 0040




