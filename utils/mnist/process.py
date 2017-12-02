from PIL import Image

file_out = open('rom.coe', 'w')
file_out.write('MEMORY_INITIALIZATION_RADIX=10;\rMEMORY_INITIALIZATION_VECTOR=\r')

for index in range(16):
    if index < 11:
        img = Image.open(str(index) + '.png').load()
    for y in range(32):
        for x in range(32):
            if index == 15 and x == 31 and y == 31:
                file_out.write('0;\r')
                continue
            if index >= 11 or x >= 28 or y >= 28:
                file_out.write('0,\r')
                continue
            if type(img[x, y]) is tuple:
                val = img[x, y][0]
            else:
                val = img[x, y]
            file_out.write(str(1 if val >= 128 else 0) + ',\r')

digits_out = open('digits.txt', 'w')
for index in range(10):
    img = Image.open(str(index) + '.png').load()
    for y in range(28):
        for x in range(28):
            if type(img[x, y]) is tuple:
                val = img[x, y][0]
            else:
                val = img[x, y]
            digits_out.write(str(1 if val >= 128 else 0) + '\n')          
