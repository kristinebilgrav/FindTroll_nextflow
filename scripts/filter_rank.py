import sys

"""
filtering using database frequency, 
ranks according to flags, vep annotation, ??
"""

output = open(sys.argv[2], 'w')


for line in open(sys.argv[1]):
    line = line.rstrip('\n')
    if line.startswith('#'):
        output.write(line)
        continue

    save = False
    
    #flags
    fl_indx = line.split('\t')[-2].split(':').index('FL')
    fl= int(line.split('\t')[-1].split(':')[fl_indx])
    if fl > 5:
        save = True

    #FRQ
    if 'FRQ' in line:
        frq = float(line.split('FRQ=')[-1].split(';')[0].split('\t')[0])
        if frq < 0.5:
            save = True

    if 'protein_coding' in line:
        save = True


    if save == True:
        output.write(line + '\n')
    else:
        continue

output.close()

