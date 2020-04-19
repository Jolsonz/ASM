;计算 z=((w-x)/10*y)
;没成功，下次再试试。
STACK SEGMENT USE16 STACK
DB 200 DUP(0)
STACK ENDS
CODE SEGMENT USE16
ASSUME SS:STACK,CS:CODE
BEGIN: MOV AX,1
       MOV BX,2
       MOV CX,Y
       SUB AX,BX
       MOV BX,10
       IDIV BX;字除法:  (DX，AX)/(OPS)→AX(商)，DX(余数),由于不保留余数，所以这里不管
       IMUL AX
       IMUL AX;平方
       MOV AH,4CH
       INT 21H
CODE ENDS
END BEGIN