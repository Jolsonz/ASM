;例4.8
.386
DATA SEGMENT USE16
BUFA DB 11H,12H,13H,14H,15H
      DB 21H,22H,23H,24H,25H
      DB 31H,32H,33H,34H,35H
      DB 41H,42H,43H,44H,45H
      M = 4
      N = 5;4行，5列
BUFS DW M DUP(?);存每行的和，即M个
DATA ENDS
STACK SEGMENT USE16 STACK
    DB 200 DUP(0)
STACK ENDS
CODE SEGMENT USE16
    ASSUME DS:DATA,SS:STACK,CS:CODE
BEGIN: mov ax,DATA
       mov ds,ax
       lea si,BUFA
       lea di,BUFS
       MOV BX,1;BX就是i
LOPI: MOV DX,0;DX就是记录本行和的东西
      MOV CX,1;CX就是j
LOPJ: MOV AL,[SI];先取值出来放在AL里
      MOVSX AX,AL;AL符号扩展后
      ADD DX,AX;加进去，要符号扩展，否则不一致。
      INC CX
      INC SI;[SI]要指向下一个单元了
      CMP CX,N;没有加完
      JBE LOPJ
      ;一行加完了
      MOV [DI],DX
      ADD DI,2;字，所以加2
      INC BX
      CMP BX,M
      JBE LOPI
      MOV AH,4CH
      INT 21H
CODE ENDS
    END BEGIN