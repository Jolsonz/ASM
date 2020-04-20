;计算 z=((w-x)/10*y)
;OK，成功了，结果应该是64,即40H，计算成功
;可能数据规模大会溢出，暂时没考虑这个。
;Z放结果
.386
DATA SEGMENT USE16
z dw ?
w dw 30
x dw 8
y dw 4
DATA ENDS

STACK SEGMENT USE16 STACK
DB 200 DUP(0)
STACK ENDS

CODE SEGMENT USE16
ASSUME CS:CODE,SS:STACK,DS:DATA
BEGIN:
       MOV AX,DATA
       MOV DS,AX
       MOV AX,W
       MOV BX,X
       SUB AX,BX
       CWD;把AX的符号扩展到DX中
       MOV BX,10
       IDIV BX; DX,AX/BX->AX商，DX余数
       MOV DX,y
       IMUL AX,DX;AX*DX->AX
       IMUL AX,AX
       MOV z,AX
       MOV AH,4CH
       INT 21H
CODE ENDS
END BEGIN