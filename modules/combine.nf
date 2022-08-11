#!/usr/bin/env nextflow

/* 
module to merge TE files to one
*/

process merge {
    publishDir params.outdir, mode:'copy'
    beforeScript 'module load bioinfo-tools bcftools'
    cpus 1
    time '1h'

    input:
    path(query)

    output:
    path "${params.sample_ID}.TEcalls.vcf.gz"

    shell:
    """
    bcftools merge ${query[:]}  -o ${params.sample_ID}.TEcalls.vcf.gz
    """
}
//${query[1]} ${query[2]} ${query[3]}
