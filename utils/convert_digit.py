#!usr/bin/env python
#-*- coding: utf-8 -*-

import sys
import numpy as np

def convert(digit_file, weight_file):
	pc = 0x0100
	with open(digit_file.rsplit('.', 1)[0] + '.data', 'w') as f:
		for line in open(digit_file, 'r'):
			ch = line[0]
			f.write('{:06X}={:04X}\n'.format(pc, ord(ch) - ord('0')))
			pc += 1

		pc = 0x2000
		weights = np.loadtxt(weight_file, np.uint16) # Load as unsigned short
		for num in weights.flat:
			f.write('{:06X}={:04X}\n'.format(pc, num))
			pc += 1


if __name__ == '__main__':
	if len(sys.argv) < 2:
		print('./convert_digit.py <digit_file> <weight_file>')
	else:
		convert(sys.argv[1], sys.argv[2])
