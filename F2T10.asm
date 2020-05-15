;功能将EAX中的32/16位有符号二进制数，转10进制输出
;入口参数EAX/AX，放待转化的有符号二进制数
;       DX放16位还是32位寄存器，即放16,32
;出口参数：转换后的带符号十进制数输出
;所用寄存器 EBX,放10，代表10进制
;          SI 放十进制数ASCII码存储区的指针
;调用子程序 Radix
F2T10  PROC 
       PUSH EBX
       PUSH SI;保护现场
       LEA SI,BUF
       CMP DX,32
       JE B;32位
       MOVSX EAX,AX;不是32位的给符号扩展到32位，不然16位负数可能会出错。
B:     OR EAX,EAX
       JNS PLUS;为正转
       NEG EAX;NEG是单操作数，将OPD的每一位取反（包括符号位）后加1→OPD,算得上是求绝对值了，因为符号位变了
       MOV BYTE PTR [SI] , '-';先放入符号
       INC SI
PLUS: MOV EBX,10;10进制,EBX是radix的入口参数。
      CALL RADIX;转成10进制数放在BUF存储区。
      MOV BYTE PTR [SI],'$';末尾加结束符
      LEA DX,BUF;输出内容。
      MOV AH,9
      INT 21H
      POP SI
      POP EBX;恢复现场
      RET
F2T10 ENDP


;顺带一提，这个改成无符号的也简单
;其实AX都可以不用扩展了。DX这个参数也不需要了
F2T10  PROC 
       PUSH EBX
       PUSH SI;保护现场
       LEA SI,BUF
       CMP DX,32
       JE B
       MOVZX EAX,AX;无符号版本直接扩展0就是。
B:
    MOV EBX,10;10进制,EBX是radix的入口参数。
    CALL RADIX
    MOV BYTE PTR [SI],'$';末尾加结束符，Radix里面没有给加结束符的
    LEA DX,BUF;输出内容。
    MOV AH,9
    INT 21H
    POP SI
    POP EBX;恢复现场
    RET
F2T10 ENDP