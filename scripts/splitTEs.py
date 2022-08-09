import sys

name = sys.argv[1]

herv = open(name + '.HERV.vcf', 'w')
alu = open(name + '.ALU.vcf', 'w')
l1 = open(name + '.L1.vcf', 'w')
sva = open(name + '.SVA.vcf', 'w')

for line in open(sys.argv[2]):
	if line.startswith('#'):
		herv.write(line)
		alu.write(line)
		l1.write(line)
		sva.write(line)
	element =line.rstrip('\n').split('MEINFO=')[-1].split(',')[0].split('-')
	if len(element) > 1:
		continue
	if 'ALU' in element:
		alu.write(line)
	if 'HERV' in element:
		herv.write(line)
	if 'L1' in element:
		l1.write(line)
	if 'SVA' in element:
		sva.write(line)
		
herv.close()
sva.close()
alu.close()
l1.close()
