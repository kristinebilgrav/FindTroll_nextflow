#!/usr/bin/env nextflow

/* 
module to split file into respective TE types
*/

process run_split {
    publishDir params.output, mode:'copy'
    input:
    path(annotated_vcf)

    output:
    path "${annotated_vcf.baseName}.*.vcf" 



    script:
    """
    python ${params.working_dir}/scripts/splitTEs.py  ${annotated_vcf.baseName} ${annotated_vcf}
    """ 
}