section .bss

a: resq 1
b: resq 1
c: resq 1
b_square: resq 1
ac4: resq 1
b2_4ac: resq 1
sqrtb2_4ac: resq 1
sqrtb2_4acby2a : resq 1
a2: resq 1
_bby2a: resq 1

r2: resq 1
r1: resq 1

%macro myprintf 1
   mov rdi,formatpf
   sub rsp,8
   movsd xmm0,[%1]
   mov rax,1
   call printf
   add rsp,8
%endmacro


%macro myscanf 1
   mov rdi,formatsf
   mov rax,0
   sub rsp,8
   mov rsi,rsp 
   call scanf
   mov r8,qword[rsp]
   mov qword[%1],r8
   add rsp,8
%endmacro


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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .data

ff1: db "%lf + i%lf",0x0A,0
ff2: db "%lf - i%lf",0x0A,0
formatpf: db "%lf",10,0    ;;no 0x0A only 10 here
formatsf: db "%lf",0     ;; IMP no 10 here

extern printf,scanf

msg1: db "Quadratic Equation:",0x0A
len1: equ $- msg1

msg2: db "Enter first coeff a:",0x0A
len2: equ $- msg2

msg3: db "Enter second coeff b:",0x0A
len3: equ $- msg3

msg4: db "Enter third coeff c:",0x0A
len4: equ $- msg4	

four: dq 4 
minus: dq -1
two: dq 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text

global main
main:
	
	
	print msg2,len2
	
	myscanf a
	myprintf a
	
	print msg3,len3
	myscanf b
	myprintf b
	
	print msg4,len4
	myscanf c
	myprintf c
	
	finit    
	
	fldz		 ;; for b square
	fld qword[b]
	fmul qword[b]
	fstp qword[b_square]
	;;myprintf b_square
	
	fldz		 
	fild qword[four]
	fmul qword[c]
	fmul qword[a]
	fstp qword[ac4]
	;;myprintf ac4
	
	fldz		 
	fld qword[b_square]
	fsub qword[ac4]
	fstp qword[b2_4ac]
	;;myprintf b2_4ac
	
	
	
	
	fldz		 
	fild qword[two]
	fmul qword[a]
	fstp qword[a2]
	;;myprintf a2
	
	mov rax,qword[b2_4ac]
	btr rax,63
	jc imaginary
	
	
	fldz		 
	fld qword[b2_4ac]
	fsqrt
	fstp qword[sqrtb2_4ac]
	;;myprintf sqrtb2_4ac
	
	fldz		 
	fadd qword[sqrtb2_4ac]
	fdiv qword[a2]
	fstp qword[sqrtb2_4acby2a]
	;;myprintf sqrtb2_4acby2a
	;
	fldz		 ;; 
	fadd qword[b]
	fimul dword[minus]
	fdiv qword[a2]
	fstp qword[_bby2a]
	;;myprintf _bby2a
	
	
	fldz
	fld qword[_bby2a]
	fadd qword[sqrtb2_4acby2a]
	fstp qword[r1]
	myprintf r1
	
	
	fldz
	fadd qword[_bby2a]
	fsub qword[sqrtb2_4acby2a]
	fstp qword[r2]
	myprintf r2
	
	
	
	jmp exit
	
	
	imaginary: 
	
	fldz		 
	fld qword[b2_4ac]
	fsqrt
	fstp qword[sqrtb2_4ac]
	;;myprintf sqrtb2_4ac
	
	fldz		 
	fadd qword[sqrtb2_4ac]
	fdiv qword[a2]
	fstp qword[sqrtb2_4acby2a]
	;;myprintf sqrtb2_4acby2a
	
	fldz		
	fadd qword[b]
	fimul dword[minus]
	fdiv qword[a2]
	fstp qword[_bby2a]
	;;myprintf _bby2a
	
	
	fldz
	fadd qword[_bby2a]
	fadd qword[sqrtb2_4acby2a]
	;;myprintf sqrtb2_4acby2a
	
	   mov rdi,ff1
	   sub rsp,8
	   movsd xmm0,qword[_bby2a]
	   movsd xmm1,qword[sqrtb2_4acby2a]
	   mov rax,2
	   call printf
	   add rsp,8
   
   
     	   mov rdi,ff2
	   sub rsp,8
	   movsd xmm0,qword[_bby2a]
	   movsd xmm1,qword[sqrtb2_4acby2a]
	   mov rax,2
	   call printf
	   add rsp,8
	
		
	 
	exit:
	mov rax,60
	mov rdi,0
	syscall


;;OUTPUT
pratik@pratik-VirtualBox:~/MP/Assign10$ nasm -f elf64 Assign10.asm
pratik@pratik-VirtualBox:~/MP/Assign10$ gcc  -o Assign10 Assign10.o
pratik@pratik-VirtualBox:~/MP/Assign10$ ./Assign10
Enter first coeff a:
1 
1.000000
Enter second coeff b:
2
2.000000
Enter third coeff c:
1
1.000000
-1.000000
-1.000000


