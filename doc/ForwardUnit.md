# Input

* EXMEMRegWrite
* MEMWBRegWrite
* EXMEMRegDest(3:0)
* MEMWBRegDest(3:0)
* IDEXERegSrcA(3:0)
* IDEXERegSrcB(3:0)

# Output

* ForwardA(1:0)
* ForwardB(1:0)

ForwardUnit用于实现解决数据冲突的数据旁路。
其根据EXMEM和MEMWB两个阶段寄存器中的数据和IDEX中（当前指令）进行判断是否需要进行旁路，然后对两个源操作数产生两个三路选择器的控制信号。
三路选择器分别接的是：寄存器直接读出的结果，EXMEM旁路回来的结果，和MEMWB旁路出来的结果。

```Pseudocode
if (EXMEMRegWrite = '1' and (EXMEMRegDest = IDEXERegSrcA)) then
    ForwardA = "01"
elsif (MEMWBRegDest = '1' and
       MEMWBRegDest = IDEXERegSrcA and
       not (EXMEMRegWrite = '1' and EXMEMRegDest = IDEXERegSrcA)) then
    ForwardA = "10"
else
    ForwardA = "00"
end if;
```

```
if (EXMEMRegWrite = '1' and (EXMEMRegDest = IDEXERegSrcB)) then
    ForwardB = "01"
elsif (MEMWBRegDest = '1' and
       MEMWBRegDest = IDEXERegSrcB and
       not (EXMEMRegWrite = '1' and EXMEMRegDest = IDEXERegSrcB)) then
    ForwardA = "10"
else
    ForwardA = "00"
end if;
```