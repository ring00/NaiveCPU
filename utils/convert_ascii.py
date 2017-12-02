#!usr/bin/env python
#-*- coding: utf-8 -*-

import sys

def convert(filename):
	pc = 0x0100
	with open(filename.rsplit('.', 1)[0] + '.data', 'w') as f:
		for line in open(filename, 'r'):
			for ch in line.rstrip('\n'):
				f.write('{:06X}={:04X}\n'.format(pc, ord(ch)))
				pc += 1

if __name__ == '__main__':
	if len(sys.argv) < 2:
		print('./convert_ascii.py <filename>')
	else:
		convert(sys.argv[1])