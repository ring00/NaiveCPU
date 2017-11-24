# Extender

## Input

* Instruction(15 downto 0)

## Output

* Extended(15 downto 0)

## 说明

观察指令分析表可知立即数扩展有一下几类

1. Instruction(7 downto 0) 符号扩展
2. Instruction(7 downto 0) 无符号扩展
3. Instruction(3 downto 0) 符号扩展
4. Instruction(4 downto 0) 符号扩展
5. Instruction(4 downto 2) 无符号扩展
6. Instruction(10 downto 0) 符号扩展
