import sys

with open(sys.argv[1],'r') as fp:
	lines = [line.rstrip('\n') for line in fp]
with open('_' + sys.argv[1],'w') as fpout:
	fpout.write('{ "data": [\n')
	for i in range(len(lines)-1):
		fpout.write(lines[i] + ',\n')
	fpout.write(lines[-1] + '\n')
	fpout.write(']}')