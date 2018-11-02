 ALP for TSR Real Time Clock.

.MODEL TINY
.286
ORG 100H				;prog seg prefix address hex no of 256


CODE SEGMENT
     ASSUME CS:CODE,DS:CODE,ES:CODE    ;giving code segment name
        OLD_IP DW 00
        OLD_CS DW 00
JMP INIT

MY_TSR:
        PUSH AX		      ;to Save the context of every register,push it onto stack,so when we are done with OUR ISR, we have to reinitialise the things that was before we changed it
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI
        PUSH DI
        PUSH ES

        MOV AX,0B800H         ;Address of Video RAM(adress of pixel where we want to display our clock)
        MOV ES,AX             ;es has base and bx has offset by default
        MOV DI,3650


        MOV AH,02H            ;for charachter output
        INT 1AH               ;To Get System Clock CH=Hrs, CL=Mins,DH=Sec                    
        MOV BX,CX

        MOV CL,2               
LOOP1:  ROL BH,4
        MOV AL,BH
        AND AL,0FH
        ADD AL,30H
        MOV AH,17H
        MOV ES:[DI],AX
        INC DI
        INC DI
        DEC CL
        JNZ LOOP1

        MOV AL,':'
        MOV AH,97H
        MOV ES:[DI],AX
        INC DI
        INC DI

        MOV CL,2
LOOP2:  ROL BL,4
        MOV AL,BL
        AND AL,0FH
        ADD AL,30H
        MOV AH,17H
        MOV ES:[DI],AX
        INC DI
        INC DI
        DEC CL
        JNZ LOOP2

        MOV AL,':'
        MOV AH,97H
        MOV ES:[DI],AX

        INC DI
        INC DI

        MOV CL,2
        MOV BL,DH

LOOP3:  ROL BL,4
        MOV AL,BL
        AND AL,0FH
        ADD AL,30H
        MOV AH,17H
        MOV ES:[DI],AX
        INC DI
        INC DI
        DEC CL
        JNZ LOOP3
;exit:
        POP ES
        POP DI
        POP SI
        POP DX
        POP CX
        POP BX
        POP AX

       
;---------------------initialization--------------------------
INIT:
        
        ;We have to temporarily save the data ,so we can make space for our program in IVT
        ;And then we can switch to our own service routine
        ;So thats why we move contents of CS to DS 
        
        MOV AX,CS              ;Initialize data
        MOV DS,AX

        CLI                    ;Clear Interrupt Flag so that our program can run

        MOV AH,35H             ;This is ORIGINAL Interrupt service routine present in 08H, So here we are getting its address to store OUR NEW routine 
        MOV AL,08H	       ;interrupt no. 8-> for timer
        INT 21H		       ;just like syscall in nasm

        
        ;After reaching 35H address we are saving its base and offset
        MOV OLD_IP,BX          ;base(2 bytes) is saved to old_ip temporarily
        MOV OLD_CS,ES          ;offset(2 bytes) is saved

        ;Now we have to put the address of OUR own interrupt service routine, And whatever there is in routine is in MY_TSR 
        MOV AH,25H             ;Set new Interrupt vector to OUR ISR
        MOV AL,08H	       ;interrupt no. 8-> for timer 
        LEA DX,MY_TSR
        INT 21H		       ;just like syscall in nasm

        MOV AH,31H             ;Make program Transient,31H activates it & gets loaded into RAM (terminates but stays resident into RAM), basically initialises program
        MOV DX,OFFSET INIT     ;size of program
        STI		       ;set interrupt flag
        INT 21H		       ;just like syscall in nasm

CODE ENDS

END

;;Commands to execute..

Tasm FileName.asm

Tlink FileName.obj

FileName.exe
