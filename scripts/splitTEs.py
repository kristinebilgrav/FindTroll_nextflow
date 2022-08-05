import sys

herv = open(name + '_HERV.vcf', 'w')
alu = open(name + '_ALU.vcf', 'w')
l1 = open(name + '_L1.vcf', 'w')
sva = open(name + '_SVA.vcf', 'w')

for line in open(snakemake.input[0]):
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
