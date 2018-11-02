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


b:resb 16
choice: resb 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .data


msg0: db "1.overlap without string",0x0A
	db "2.overlap with string",0x0A
	db "3.non-overlap without string",0x0A
	db "4.non-overlap with string",0x0A
	db "5.Exit",0x0A
len0: equ $- msg0


msg: db " : "
len: equ $- msg

msg1: db 0x0A
len1: equ $- msg1

msg2: db "AFTER COPYING"
len2: equ $- msg2

count: db 5
cnt: db 0

array: dq 0x1234ABCD1234ADAD,0x45677833453AABCD,0x55677833453AABCD,0x65677833453AABCD,0x7234ABCD1234ADAD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text

global main
main:
	print msg0,len0
	read choice,2
	cmp byte[choice],31H
	je case1
	cmp byte[choice],32H
	je case2
	cmp byte[choice],33H
	je case3
	cmp byte[choice],34H
	je case4
	cmp byte[choice],35H
	je case5


case1:
;;DISPLAYING ORIGINAL ARRAY

	mov byte[count],5
	mov rsi,array
	case1up:
	mov rbx,rsi
	push rsi
	call htoa_16
	print msg,len
	pop rsi
	mov rbx,qword[rsi]
	push rsi
	call htoa_16
	print msg1,len1
	pop rsi
	add rsi,8
	dec byte[count]
	jnz case1up

	print msg1,len1

;;COPYING OVERLAPPED ARRAY
	mov byte[count],5
	mov rsi, array+32
	mov rdi,array+48
	case1up2:
	mov rbx,qword[rsi]
	mov qword[rdi],rbx
	sub rsi,8
	sub rdi,8
	dec byte[count]
	jnz case1up2

;;DISPLAYING OVERLAPPED ARRAY
	mov byte[count],7
	mov rsi,array
	case1up3:
	mov rbx,rsi
	push rsi
	call htoa_16
	print msg,len
	pop rsi
	mov rbx,qword[rsi]
	push rsi
	call htoa_16
	print msg1,len1
	pop rsi
	add rsi,8
	dec byte[count]
	jnz case1up3
	jmp main




case2:
;;PRINTING ORIGINAL ARRAY
 
	mov byte[count],5
	mov rsi,array
	case2up:
	mov rbx,rsi
	push rsi
	call htoa_16
	print msg,len
	pop rsi
	mov rbx,qword[rsi]
	push rsi
	call htoa_16
	print msg1,len1
	pop rsi
	add rsi,8
	dec byte[count]
	jnz case2up

;;COPYING ORIGINAL ARRAY USING STRING

	mov byte[count],5
	mov rsi, array
	mov rdi,array+56
	case2up2:
	movsq					 ;;MOVSQ(mov string qword) copies qword of rsi to rdi and inc rsi and rdi by 8(as qword)
	dec byte[count]
	jnz case2up2

	mov byte[count],5
	mov rsi,array+56
	mov rdi,array+16
	case2up3:
	movsq
	dec byte[count]
	jnz case2up3

	print msg1,len1




;;DISPLAYING OVERLAPPED ARRAY WITH STRING
	
	mov byte[count],7
	mov rsi,array
	case2up4:
	mov rbx,rsi
	push rsi
	call htoa_16
	print msg,len
	pop rsi
	mov rbx,qword[rsi]
	push rsi
	call htoa_16
	print msg1,len1
	pop rsi
	add rsi,8
	dec byte[count]
	jnz case2up4
	jmp main

case3:
;;DISPLAYING ORIGINAL ARRAY

	mov rsi,array
	case3up1:
	mov rbx,rsi
	push rsi
	call htoa_16
	print msg,len
	pop rsi
	mov rbx,qword[rsi]
	push rsi
	call htoa_16
	print msg1,len1
	pop rsi
	add rsi,8
	dec byte[count] 
	jnz case3up1


;;COPYING ARRAY TO OTHER LOCATION
	mov byte[count],5
	print msg2,len2 
	mov rsi,array
	mov rdi,array+90
	case3up2:
	mov rbx,qword[rsi]
	mov qword[rdi],rbx
	add rsi,8
	add rdi,8
	dec byte[count]
	jnz case3up2
	
	print msg1,len1

;;DISPLAYING NEW ARRAY
	mov byte[count],5
	mov rsi,array+90
	case3up3:
	mov rbx,rsi
	push rsi
	call htoa_16
	print msg,len
	pop rsi
	mov rbx,qword[rsi]
	push rsi
	call htoa_16
	print msg1,len1
	pop rsi
	add rsi,8
	dec byte[count] 
	jnz case3up3
	
	jmp main
	

case4:
;;DISPLAYING ORIGINAL ARRAY

	mov byte[count],5
	mov rsi,array
	case4up1:
	mov rbx,rsi
	push rsi
	call htoa_16
	print msg,len
	pop rsi
	mov rbx,qword[rsi]
	push rsi
	call htoa_16
	print msg1,len1
	pop rsi
	add rsi,8
	dec byte[count]
	jnz case4up1

	print msg2,len2

;;COPYING ORIGINAL ARRAY USING STRING

	mov byte[count],5
	mov rsi, array
	mov rdi,array+56
	case4up2:
	movsq                      ;;MOVSQ(mov string qword) copies qword of rsi to rdi and inc rsi and rdi by 8(as qword) 
	dec byte[count]
	jnz case4up2


	print msg1,len1



;;DISPLAYING NEW ARRAY WITH STRING
	
	mov byte[count],5
	mov rsi,array+56
	case4up4:
	mov rbx,rsi
	push rsi
	call htoa_16
	print msg,len
	pop rsi
	mov rbx,qword[rsi]
	push rsi
	call htoa_16
	print msg1,len1
	pop rsi
	add rsi,8
	dec byte[count]
	jnz case4up4
	


	jmp main


case5:
	mov rax,60
	mov rdi,0
	syscall



htoa_16:

	mov rdi,b
	mov byte[cnt],16
	up:
	rol rbx,04
	mov dl,bl
	and dl,0FH
	cmp dl,09
	jbe next5
	add dl,07

	next5:
	add dl,30H
	mov byte[rdi],dl
	inc rdi
	dec byte[cnt]
	jnz up
	print b,16
	ret

;;OUTPUT

pratik@pratik-VirtualBox:~/MP/Assign2$ nasm -f elf64 Assign2.asm
pratik@pratik-VirtualBox:~/MP/Assign2$ ld -o Assign2 Assign2.o
ld: warning: cannot find entry symbol _start; defaulting to 00000000004000b0
pratik@pratik-VirtualBox:~/MP/Assign2$ ./Assign2
1.overlap without string
2.overlap with string
3.non-overlap without string
4.non-overlap with string
5.Exit
1
00000000006006BC : 1234ABCD1234ADAD
00000000006006C4 : 45677833453AABCD
00000000006006CC : 55677833453AABCD
00000000006006D4 : 65677833453AABCD
00000000006006DC : 7234ABCD1234ADAD
AFTER COPYING
00000000006006BC : 1234ABCD1234ADAD
00000000006006C4 : 45677833453AABCD
00000000006006CC : 1234ABCD1234ADAD
00000000006006D4 : 45677833453AABCD
00000000006006DC : 55677833453AABCD
00000000006006E4 : 3030303030303030
00000000006006EC : 4345363030363030
1.overlap without string
2.overlap with string
3.non-overlap without string
4.non-overlap with string
5.Exit
2
00000000006006BC : 1234ABCD1234ADAD
00000000006006C4 : 45677833453AABCD
00000000006006CC : 1234ABCD1234ADAD
00000000006006D4 : 45677833453AABCD
00000000006006DC : 55677833453AABCD
AFTER COPYING
00000000006006BC : 1234ABCD1234ADAD
00000000006006C4 : 45677833453AABCD
00000000006006CC : 1234ABCD1234ADAD
00000000006006D4 : 45677833453AABCD
00000000006006DC : 1234ABCD1234ADAD
00000000006006E4 : 3030303030303030
00000000006006EC : 4345363030363030
1.overlap without string
2.overlap with string
3.non-overlap without string
4.non-overlap with string
5.Exit
3
00000000006006D8 : 1234ABCD1234ADAD
00000000006006E0 : 45677833453AABCD
00000000006006E8 : 55677833453AABCD
00000000006006F0 : 65677833453AABCD
00000000006006F8 : 7234ABCD1234ADAD
AFTER COPYING
0000000000600732 : 1234ABCD1234ADAD
000000000060073A : 45677833453AABCD
0000000000600742 : 55677833453AABCD
000000000060074A : 65677833453AABCD
0000000000600752 : 7234ABCD1234ADAD
1.overlap without string
2.overlap with string
3.non-overlap without string
4.non-overlap with string
5.Exit
4
00000000006006D8 : 1234ABCD1234ADAD
00000000006006E0 : 45677833453AABCD
00000000006006E8 : 55677833453AABCD
00000000006006F0 : 65677833453AABCD
00000000006006F8 : 7234ABCD1234ADAD
AFTER COPYING
0000000000600710 : 1234ABCD1234ADAD
0000000000600718 : 45677833453AABCD
0000000000600720 : 55677833453AABCD
0000000000600728 : 65677833453AABCD
0000000000600730 : 7234ABCD1234ADAD
1.overlap without string
2.overlap with string
3.non-overlap without string
4.non-overlap with string
5.Exit
5



