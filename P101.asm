;例4-1，求0-9的立方值
;例如，我想输出结果该怎么输出？2号调用？那就要先把数字转ASCII码，然后再一个一个输出？
;数字转单个数字需要用除法把，我太难了，等下再搞，应该是如果是数字就or 3030h，如果是字母要or 4141h。。
.386
DATA SEGMENT USE16
INPUT DB 'Please inpute X(0~9):$'
TAB DW 0,1,8,27,64,125,216,343,512,729
X DB ?
XXX DW ?
C dw 0DH,0AH,'$'
DATA ENDS
STACK SEGMENT USE16 STACK
DB 200 DUP(0)
STACK ENDS
CODE SEGMENT USE16
ASSUME CS:CODE,DS:DATA,SS:STACK
BEGIN:
    MOV AX,DATA
    MOV DS,AX
    MOV DX,OFFSET INPUT
    MOV AH,9;输出字符串
    INT 21H
    MOV AH,1
    INT 21H;接受一个字符，读入AL

    AND AL,0FH;这一步必须要，因为例如读入5，实际上是读入35H（ASCII),所以要去掉3，变成05H，必须要and 0FH。

    MOV X,AL;把X的值读入
    XOR EBX,EBX;置0
    MOV BL,AL;al的真值放在B里
    MOV AX,TAB[2*EBX];变址寻址,为16位寄存器的时候F只能为1，这里F要取2，所以只能取32位寄存器。
    MOV XXX,AX
    MOV AH,4CH
    INT 21H
CODE ENDS
END BEGIN