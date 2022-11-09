#!/usr/bin/env nextflow

/* 
module to merge TE files to one and delete unneeded files 
*/

process svdb_merge {
    publishDir params.output, mode:'copy'

    cpus 1
    time '1h'

    input:
    path(called_vcf)
    path(DR_vcf)

    output:
    path "${called_vcf.simpleName}.called.vcf", emit: all_calls

    script:
    """
    svdb --merge --vcf  ${called_vcf} ${DR_vcf} --bnd_distance 150 > ${called_vcf.simpleName}.all.called.vcf &&
    python ${params.working_dir}/scripts/filter_MAtoTEs.py ${called_vcf.simpleName}.all.called.vcf ${called_vcf.simpleName}.called.vcf
    """
    
}

process merge_calls {
    publishDir params.output, mode:'copy'
    errorStrategy 'ignore'
    cpus 1
    time '1h'

    input:
    path queryList
 
    output:
    path "${queryList[0].simpleName}.TEcalls.vcf.gz"

    script:
    """
    zgrep '#' ${queryList[0]} > ${queryList[0].simpleName}.TEcalls.vcf.gz |
    for qFile in ${queryList}
    do
        zgrep -v '#' \$qFile  >> ${queryList[0].simpleName}.TEcalls.vcf.gz 
    done 
    """
}

