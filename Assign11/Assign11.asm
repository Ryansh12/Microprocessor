Section .data
msg1: db "Numbers are 101.56, 103.44, 111.98, 108.32, 105.44",0x0A
len1: equ $-msg1

msg2: db "Mean is: "
len2: equ $-msg2

msg3: db "Variance is: "
len3: equ $-msg3

msg4: db "Standard Deviation is: "
len4: equ $-msg4

array: dd 101.56, 103.44, 111.98, 108.32, 105.44
arraycnt: dw 05
point: db '.'
mul: dq 100
newline: db 0x0A

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Section .bss
mean: resd 1
variance: resd 1
s_d: resd 1
buffer: resb 10
count: resb 1
ans: resb 2
cnt: resb 1

%macro print 2
MOV rax,1
MOV rdi,1
MOV rsi,%1
MOv rdx,%2
Syscall
%endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Section .text
global main
main:

FINIT
FLDZ
MOV rsi,array
MOV byte[count],5

up1:
FADD dword[rsi]
ADD rsi,4
DEC byte[count]
JNZ up1

FIDIV word[arraycnt]
FST dword[mean]
print msg2,len2
CALL display
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV rsi,array
MOV byte[count],5

FLDZ
n1:
FLDZ
FADD dword[rsi]
FSUB dword[mean]
FMUL ST0
FADD
ADD rsi,4
DEC byte[count]
JNZ n1

FIDIV word[arraycnt]
FST dword[variance]
print msg3,len3
CALL display
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FLD dword[variance]
FSQRT
FST dword[s_d]
print msg4,len4
CALL display

JMP exit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
display:
FIMUL dword[mul]
FBSTP tword[buffer]

MOV rsi,buffer
ADD rsi,9
MOV byte[count],9
xy:
MOV cl,byte[rsi]
push rsi
CALL htoa_2
POP rsi
DEC rsi
DEC byte[count]
JNZ xy
print point,1
MOV cl,byte[buffer]
CALL htoa_2
print newline,1
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
htoa_2:
MOV rdi,ans
MOV byte[cnt],2
uv:
ROL cl,04
MOV dl,cl
AND dl,0FH
CMP dl,09
JBE hi
ADD dl,07
hi:
ADD dl,30H
MOV byte[rdi],dl
INC rdi
DEC byte[cnt]
JNZ uv
print ans,2

RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exit:
MOV rax,60
MOV rdi,0
Syscall
