import sys

"""
indentifies genes from gene list that could be TE affected
"""

gene_list = sys.argv[1]
TE_file = sys.argv[2]
output = open(sys.argv[3], 'w')

genes = []
for gene in gene_list:
    gene = gene.rstrip('\n')
    if gene not in genes:
        genes.append(gene)


for line in open(TE_file):
    line= line.rstrip('\n')
    if line.startswith('#'):
        output.write(line + '\n')
        if 'CSQ' in line:
            gene_indx = line.split('|').index('SYMBOL')
            exon_indx = line.split('|').index('EXONS')

        continue

    gene = line.split('CSQ=')[-1].split('|')[gene_indx]
    exon = line.split('CSQ=')[-1].split('|')[exon_indx].split('\t')[0]
    if gene in genes:
        output.write(line + '\n')
    
    if exon in genes: 
        output.write(line + '\n')