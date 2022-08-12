#!/usr/bin/env nextflow

/* 
module to merge TE files to one and delete unneeded files 
*/

process merge {
    publishDir params.outdir, mode:'copy'
    errorStrategy 'ignore'
    cpus 1
    time '1h'

    input:
    file queryList

    output:
    path "${params.sample_ID}.TEcalls.vcf.gz"

    shell:
    """
    zgrep '#' ${queryList[0]} > ${params.sample_ID}.TEcalls.vcf.gz |
    for qFile in ${queryList}
    do
        zgrep -v '#' \$qFile  >> ${params.sample_ID}.TEcalls.vcf.gz && rm \$qFile
    done 
    """
}

process clean {

    shell:
    """
    rm -rf ${params.tmpdir}
    """

}



