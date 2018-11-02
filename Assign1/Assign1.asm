section .data

msg: db "Array is:",0x0A
len: equ $-msg

msg1: db "No of positive nos:"
len1: equ $-msg1

msg2: db 0x0A,"No of negative nos:"
len2: equ $-msg2

array: dw 1234H,0xABCD,0xDCBA,4321H,0xE432,0xFAD2,0x1287,5490H,4892H,0x1DCA
msga: db "1234H,ABCDH,DCBAH,4321H,E432H,FAD2H,1287H,5490H,4892H,FDCAH",0x0A
lena: equ $-msga

pos: db 0
neg: db 0
count: db 10 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .text
global main
main:


mov rsi,array
up:
mov ax,word[rsi]
BT ax,15
jc next
inc byte[pos]
add rsi,2
dec byte[count]
jnz up
jmp next2

next:
inc byte[neg]
add rsi,2
dec byte[count]
jnz up

next2:
cmp byte[pos],9
jbe next3
add byte[pos],7H

next3: 
add byte[pos],30H

cmp byte[neg],9
jbe next4
add byte[neg],7H

next4: 
add byte[neg],30H




mov rax,1
mov rdi,1
mov rsi,msg
mov rdx,len
syscall


mov rax,1
mov rdi,1
mov rsi,msga
mov rdx,lena
syscall

mov rax,1
mov rdi,1
mov rsi,msg1
mov rdx,len1
syscall


mov rax,1
mov rdi,1
mov rsi,pos
mov rdx,1
syscall


mov rax,1
mov rdi,1
mov rsi,msg2
mov rdx,len2
syscall


mov rax,1
mov rdi,1
mov rsi,neg
mov rdx,1
syscall

mov rax,60
mov rdi,0
syscall




;;OUTPUT
;;pratik@pratik-VirtualBox:~/MP/Assign1$ nasm -f elf64 Assign1.asm
;;pratik@pratik-VirtualBox:~/MP/Assign1$ ld -o Assign1 Assign1.o
;;ld: warning: cannot find entry symbol _start; defaulting to 00000000004000b0
;;pratik@pratik-VirtualBox:~/MP/Assign1$ ./Assign1
;;Array is:
;;1234H,ABCDH,DCBAH,4321H,E432H,FAD2H,1287H,5490H,4892H,FDCAH
;;No of positive nos:6
;;No of negative nos:4




