1. masm+ .asm来汇编，得到OBJ
2. 用link + .obj来连接 得到EXE
3. debug+ .exe来进行调试

### 下面是调试命令详解(常用的，其他的可以见印象笔记)
1. r 观看和修改寄存器的值
   -  在提示符“-”下输入以下命令：R。DEBUG将会显示出当前所有寄存器和标志位的状态。
   - 接下来再输入命令RCX。在提示符“：”后输入100。该命令的作用是将寄存器CX的值设置为100（注意：DEBUG使用的是十六进制，这里的100相当于十进制的256。）
   - 最后再执行R命令，观看修改后的寄存器值。
   - 注意不能看EAX这种32位寄存器，因为这debug程序是16位的，要用debug32才行
2. d 显示内存区域的内容。
   注意因为往往不是显示的首地址，还需自己修改
   例如输入 d 0，才会挪到首地址去。
3. u 对机器代码反汇编显示。
   U命令的使用方法是：U [范围]。如果范围参数只输入了起始地址，则只对20H个字节的机器代码反汇编。执行命令U100，观看反汇编结果。执行命令U100 10B，观看反汇编结果。该命令的作用是对从100到10B的机器代码进行反汇编。
4. q 退出DEBUG，回到DOS状态。
5. t 单步调试
6. g 执行到某个地址停下，若不指定，就直接到结尾

位置	标志名	标志为1	标志为0
11	OF	溢出(是/否)	OV	NV
10	DF	方向（减量/增量）	DN	UP
9	IF	中断(允许/关闭)	EI	DI
7	SF	符号(负/正)	NG	PL
6	ZF	零(是/否)	ZR	NZ
4	AF	辅助进位（是/否）	AC	NA
2	PF	奇偶(偶/奇）	PE	PO
0	CF	进位（是/否）	CY	NC

---
- Radix函数和F2T10函数都要能写出来才可以。真的挺好用的。考试也可能考实现。