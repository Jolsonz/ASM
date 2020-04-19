;有关DOS调用
;例3.15
;用于从键盘输入一串字符，在下一行显示出来。
.386
data segment use16
buf db 50
    db 0;实际字符数
    db 50 dup(0);输入缓冲区
    crlf db 0dh,0ah,'$';回车换行
data ends
stack segment use16 stack
db 200 dup(0)
stack ends
code segment use16
assume ds:data,ss:stack,cs:code
start: mov ax,data
       mov ds,ax
       lea dx,buf;往buf里输入字符串
       mov ah,10
       int 21h
       lea dx,crlf;输出回车换行
       mov ah,9
       int 21h
       movsx bx,buf+1;缓冲区的第二个字节，存实际字符个数。
       mov byte ptr buf+2[bx],'$';串末尾放一个结束符。因为这寄存器最低都是16位，所以用BX
       lea dx,buf+2
       mov ah,9;输出字符串。
       int 21h
       mov ah,4ch
       int 21h
code ends
end start

