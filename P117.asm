;例4.5，单重循环设计。
.386
DATA SEGMENT USE16
BUF DW -5,100,34,20,-1,-1999,0,300,24,-449
N = ($-BUF)/2
BUF1 DW N DUP(?) ;正数存储
BUF2 DW N DUP(?) ;负数存储
DATA ENDS
STACK SEGMENT USE16 STACK
    DB 200 DUP(0)
STACK ENDS
CODE SEGMENT USE16
    ASSUME CS:CODE,DS:DATA,SS:STACK
BEGIN: MOV AX,DATA
       MOV DS,AX
       LEA BX,BUF
       LEA SI,BUF1
       LEA DI,BUF2
       MOV CX,N
LOPA: MOV AX,[BX] ;BX只是存了EA，所以要加[]取EA，然后再把(EA)给AX
      CMP AX,0
      JGE L1 ;当前元素非负，转L1
      MOV [DI],AX ;把AX的内容给[DI]
      ADD DI,2
      JMP NEXT
L1: MOV [SI],AX
    ADD SI,2
NEXT: ADD BX,2
      DEC CX
      JNZ LOPA
      MOV AH,4CH
      INT 21H
CODE ENDS
    END BEGIN