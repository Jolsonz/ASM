;例4.11
;将EAX中的32位有符号二进制数（或AX中的有符号二进制数）以十进制数形式输出的子程序F2T10
; 这玩意儿能独立写出来就挺强了。
.386
DATA SEGMENT USE16
BUF DB 15 DUP(?) ;F2T10的缓冲区
BUFB DD 80000000H,7FFFFFFFH,0,0FFFFFFFFH,20H,64H
N = ($-BUFB)/4
DATA ENDS
STACK SEGMENT USE16 STACK
DB 200 DUP(0)
STACK ENDS
CODE SEGMENT USE16
ASSUME CS:CODE,DS:DATA,SS:STACK
BEGIN: MOV AX,DATA
       MOV DS,AX
       MOV CX,N;待转化二进制数的个数
       LEA DI,BUFB
LOPA: MOV EAX,[DI]
      MOV DX,32;说明是32位寄存器的
      CALL F2T10
      MOV DL,'/'
      MOV AH,2
      INT 21H
      ADD DI,4;指针后移4
      LOOP LOPA
      MOV AH,4CH
      INT 21H
;将EAX中的32/16位有符号二进制数，转10进制输出
F2T10  PROC 
       PUSH EBX
       PUSH SI;保护现场
       LEA SI,BUF
       CMP DX,32
       JE B
       MOVSX EAX,AX;不是32位的给符号扩展到32位，不然16位负数可能会出错。
B:     OR EAX,EAX
       JNS PLUS;为正转
       NEG EAX;NEG是单操作数，将OPD的每一位取反（包括符号位）后加1→OPD,算得上是求绝对值了，因为符号位变了
       MOV BYTE PTR [SI] , '-';先放入符号
       INC SI
PLUS: MOV EBX,10;10进制,EBX是radix的入口参数。
      CALL RADIX
      MOV BYTE PTR [SI],'$';末尾加结束符
      LEA DX,BUF;输出内容。
      MOV AH,9
      INT 21H
      POP SI
      POP EBX;恢复现场
      RET
F2T10 ENDP

RADIX PROC
      PUSH CX
      PUSH EDX ;保护现场
      XOR CX,CX;计数器清0
LOP1: XOR EDX,EDX;清0
      DIV EBX; 因为是32位寄存器，显然是(EDX,EAX)/(OPS)→EAX(商)、EDX(余数)
      PUSH DX; 这里可以不用EDX，因为P进制最多是3-16位，也就是说余数最多也就3-16。EDX高位必定全是0，就没必要压入EDX了。前要用EDX是因为是双字除法
      INC CX;计数
      OR EAX,EAX;只有EAX全为0才会返回0
      JNZ LOP1
;上面是计算，下面是吧结果输出来
LOP2: POP AX
      CMP AL,10;弹出一位数，实际上只要8位就行
      JB L1;小于10，就加30H
      ADD AL,7;否者加37H
L1:   ADD AL,30H
      MOV [SI],AL;存在SI指针位置
      INC SI
      LOOP LOP2;CX-1,知道CX==0
      POP EDX
      POP CX;恢复现场
      RET
RADIX ENDP
CODE ENDS
END BEGIN