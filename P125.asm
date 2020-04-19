;例4.9,在第三行后面插入一行，详细分析过程见书
.386
DATA SEGMENT USE16
BUF DB '111111',0DH,0AH
    DB '22222',0DH,0AH
    DB '3333333',0DH,0AH
    DB '4444444444444',0DH,0AH
    DB '555555555',0DH,0AH,'$',1AH;1AH也就是control+z，也就是结束符，也就是EOF，即^Z
    DB 2048-($-BUF) DUP(0);反正一共2KB空间
TT DB 0DH,0AH,'********************************************',0DH,0AH,'$'
DATA ENDS
STACK SEGMENT USE16 STACK
    db 200 DUP(0)
STACK ENDS
CODE SEGMENT USE16
    ASSUME DS:DATA,SS:STACK,CS:CODE
FIRST: MOV AX,DATA
       MOV DS,AX
;两个指针，SI指着头，BX指着尾。
NEXT: LEA SI,BUF;缓冲区首址
      MOV CX,0;行计数器cx为0
ROW_NUM: CMP BYTE PTR[SI],1AH;是^z，实际上不用做强制类型指定吧？1AH怎么想都是一个字节啊。
         JE SHIFT1
         CMP BYTE PTR[SI],0AH;是行结束符
         JNE L1;不是行结束，继续指针后移
         INC CX;行数加
L1: INC SI;指针后移
    JMP ROW_NUM
;上面完成之后，SI移到了1AH，并且记录了行数
SHIFT1: MOV BX,2048-1;BX指向缓冲区底部
        SUB CX,2;  这里之所以减2，是为了把第三行后面的所有行都移到底部，计数的，看第35行比较好理解。
S0: MOV AL,[SI];取一个准备下移的字符
    CMP AL,0AH
    JNE S2;不是换行符，就下移
    DEC CX;行数减
    JZ INPUT0;如果CX不为0，就继续，为0说明第三行后面全部行都移出了。
S2: MOV [BX],AL;移到BX位置
    DEC SI
    DEC BX;两个指针都减
    JMP S0;回去继续移
;上面是为了把第三行后面全部行移到缓冲区底部
INPUT0: MOV AH,1 ;输入一个字符到AL
        INT 21H 
        CMP AL,1AH;碰到1AH就退出，结束DOS调用
        JE EXIT
        INC SI
        MOV [SI],AL;插入到指针位置
        CMP AL,0DH;碰到回车就加一个换行
        JNE INPUT0
        INC SI
        MOV BYTE PTR[SI],0AH
SHIFT2: INC SI
        INC BX
        MOV AL,[BX]
        MOV [SI],AL;因为不能MOV [SI],[BX]，都是存储器寻址
        CMP AL,1AH;不到1AH不停
        JE OUT1
        JMP SHIFT2
;上面是为了把下移的行上上移
OUT1: LEA DX,TT
      MOV AH,9;输出DX的内容
      INT 21H
      LEA DX,BUF;再输出缓冲区的
      MOV AH,9
      INT 21H
      JMP NEXT;转入新的插入操作。
;你看44行，只有输入1AH，才结束程序。
EXIT: MOV AH,4CH
      INT 21H
CODE ENDS
END FIRST