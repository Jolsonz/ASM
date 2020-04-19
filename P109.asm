;对p101,例4-1的功能扩充，对错误输入的判断处理、
;又加了两个函数，用于输出10进制的结果。
.386
DATA SEGMENT USE16
INPUT DB 'Please inpute X(0~9):$'
CRLF DB 0DH,0AH,'$'
TAB DW 0,1,8,27,64,125,216,343,512,729
X DB ?
XXX DW ?
BUF DB 20 DUP(?);放结果字符串
INERR dB 0DH,0AH,'Inpute error! Try again.',0DH,0AH,'$'
DATA ENDS
STACK SEGMENT USE16 STACK
DB 200 DUP(0)
STACK ENDS
CODE SEGMENT USE16
ASSUME CS:CODE,DS:DATA,SS:STACK
BEGIN:
    MOV AX,DATA
    MOV DS,AX
NEXT:MOV DX,OFFSET INPUT
    MOV AH,9;输出字符串
    INT 21H
    MOV AH,1
    INT 21H;接受一个字符，读入AL
    cmp al,'0'
    JB err
    cmp al,'9'
    ja err 
    AND AL,0FH;这一步必须要，因为例如读入5，实际上是读入35H（ASCII),所以要去掉3，变成05H，必须要and 0FH。
    MOV X,AL;把X的值读入
    XOR EBX,EBX;置0
    MOV BL,AL;al的真值放在B里
    MOV AX,TAB[2*EBX];变址寻址,为16位寄存器的时候F只能为1，这里F要取2，所以只能取32位寄存器。
    MOV XXX,AX
    LEA DX,CRLF
    MOV AH,9
    INT 21H;
    MOV AX,XXX;al的值被破坏了
    CALL F2T10
EXIT: MOV AH,4CH
    INT 21H
err: MOV DX,OFFSET INERR
     MOV AH,9
     INT 21H
     JMP NEXT

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