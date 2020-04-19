;例3.16
;将变量A中的数据以二进制形式输出在屏幕上
;就是考虑一个如何输出不是字符串的数
;我还是没懂那个BT命令有什么用
.386
DATA SEGMENT USE16
AA DB 10011010B
BB DB '(A)=','$'
CC db 'B',0DH,0AH,'$'
DATA ENDS

STACK SEGMENT USE16 STACK
DB 200 DUP(0)
STACK ENDS

CODE SEGMENT USE16
ASSUME CS:CODE,SS:STACK,DS:DATA
BEGIN: MOV AX,DATA
       MOV DS,AX
       LEA DX,BB
       MOV AH,9
       INT 21H
       MOVZX BX,AA;高位补0
       MOV CX,7;实际上循环8次，但第一次不用减CX，所以CX设7即可。
L: BT BX, CX;BT命令到底什么意思？
   JC P;有进位，说明是1
   MOV DL,30H;该位为0
   JMP Q
P: MOV DL,31H;该位为1
Q: MOV AH,2;显示DL的字符
   INT 21H
   DEC CX
   JGE L
   LEA DX,CC
   MOV AH,9
   INT 21H
   MOV AH,4CH
   INT 21H
CODE ENDS
END BEGIN