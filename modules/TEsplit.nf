#!/usr/bin/env nextflow

/* 
module to split file into respective TE types
*/

process run_split {
    publishDir params.outdir, mode:'copy'
    input:
    path(annotated_vcf)

    output:
 //   path("${bam.baseName}.ALU.vcf") emit: alu_out
    path "${annotated_vcf.baseName}.*.vcf", emit: splitfiles

    script:
    """
    python ${params.working_dir}/scripts/splitTEs.py ${annotated_vcf.baseName} ${annotated_vcf}
    """ 
}