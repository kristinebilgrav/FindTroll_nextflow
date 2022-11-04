import gzip as gz
import sys

"""
filter to obtain TEs and desired chrs
"""

print('filtering' + sys.argv[1])
file= open(sys.argv[2], 'w')
deletelist= ['random', 'HLA', 'decoy', 'chrUn_', '_alt']

if 'gz' in sys.argv[1]:
        opener = gz.open
else:
     	opener = open

for line in opener(sys.argv[1], mode = 'rt'):
        save = False

        if line.startswith('#'):
                save = True

        if 'INS:ME' in line:
                save = True

        for d in deletelist:
                if d in line:
                        save = False
                        continue
                    
        if save == True:
                file.write(line)
        else:
            continue

print('filtering done')