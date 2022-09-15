#!/usr/bin/env nextflow

/* 
module to merge TE files to one and delete unneeded files 
*/

process svdb_merge {
    publishDir params.tmpfiles, mode:'copy'

    cpus 1
    time '1h'

    input:
    path calledList

    output:
    path "${params.sample_ID}.called.vcf", emit: all_calls

    script:
    """
    svdb --merge --vcf  ${calledList}[0] ${calledList}[1] --bnd_distance 150 > ${params.sample_ID}.called.vcf
    """
    
}

process merge {
    publishDir params.output, mode:'copy'
    errorStrategy 'ignore'
    cpus 1
    time '1h'

    input:
    path queryList

    output:
    path "${params.sample_ID}.TEcalls.vcf.gz"

    script:
    """
    zgrep '#' ${queryList[0]} > ${params.sample_ID}.TEcalls.vcf.gz |
    for qFile in ${queryList}
    do
        zgrep -v '#' \$qFile  >> ${params.sample_ID}.TEcalls.vcf.gz && rm \$qFile
    done 
    """
}

