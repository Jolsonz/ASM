;注意这是处理的无符号数哦。
;对Radix的调用，处理
.386
DATA SEGMENT USE16
BUFA DB 15 DUP(0)
BUFB DD 400000000,4096,18,0FFFFFFH,0F1234567H
N = ($-BUFB)/4
; K = 10;用等于号才能多次重新赋值
DATA ENDS
STACK SEGMENT USE16 STACK
DB 200 DUP(0)
STACK ENDS
CODE SEGMENT USE16
ASSUME DS:DATA,SS:STACK,CS:CODE
BEGIN: MOV AX,DATA
       MOV DS,AX
       MOV CX,N;带转换的二进制数个数
       LEA DI,BUFB
LOPA:  MOV EAX,[DI]
       OR EAX,EAX;OR操作可以重置标志位
       JGE L2
       MOV BYTE PTR [SI],'-'
       INC SI
       NEG EAX;取反加1      
       ;我想做到，是负数的话，输出符号的，可惜不知道为啥不成功，OR EAX,EAX JGEL2这步应该是无误的，应该是有哪里没注意到。
L2:    MOV EBX,10;
       LEA SI,BUFA;存结果
       CALL RADIX
       MOV BYTE PTR [SI],0DH
       MOV BYTE PTR [SI+1],0AH
       MOV BYTE PTR [SI+2],'$'
       LEA DX,BUFA
       MOV AH,9;9号调用
       INT 21H
       ;上面是显示转换后的10进制数
       MOV EAX,[DI];继续这个套路
       MOV EBX,16
       LEA SI,BUFA
       CALL RADIX
       MOV BYTE PTR [SI],'H';16进制末尾加H
       MOV BYTE PTR [SI+1],0DH
       MOV BYTE PTR [SI+2],0AH
       MOV BYTE PTR [SI+3],'$'
       LEA DX,BUFA
       MOV AH,9
       INT 21H
       ADD DI,4;指向下一个二进制数
       LOOP LOPA;直到CX==0
       MOV AH,4CH
       INT 21H
RADIX PROC
      PUSH CX
      PUSH EDX ;保护现场
      XOR CX,CX;计数器清0
LOP1: XOR EDX,EDX;清0
      DIV EBX; 因为是32位寄存器，显然是(EDX,EAX)/(OPS)→EAX(商)、EDX(余数)
      PUSH DX; 这里可以不用EDX，因为P进制最多是3-16位，也就是说余数最多也就3-16。EDX高位必定全是0，就没必要压入EDX了。前要用EDX是因为是双字除法
      ;另外PUSH/POP只能是字/双字。不能是字节，不然会warning,我无视了，但输出不正确。所以还是正常压入字吧
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
      