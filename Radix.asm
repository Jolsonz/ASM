;基数转换子程序RADIX
;P135
;RADIX将EAX中32位无符号二进制数转为P进制数（3-16中的任意一个整数）
;入口参数:
; EAX 存放待转化的32位无符号数
; EBX 存放要转换数制的基数，也就是P
; SI 存放转换后的P进制ASCII码数字串的字节缓冲首址
; 出口参数
; 所求P进制ASCII码数字按高位在前，低位在后，放在SI为首址的字节缓冲区。
; 所用寄存器——记得现场保护
; CX计数，记录进栈的P进制数字的个数，以及控制同样的出栈个数
; EDX-做除法时存放被除数高位或者余数。
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
      ADD AL,7;否者加37H，从A开始
L1:   ADD AL,30H
      MOV [SI],AL;存在SI指针位置
      INC SI
      LOOP LOP2;CX-1,直到CX==0
      POP EDX
      POP CX;恢复现场
      RET
RADIX ENDP
    