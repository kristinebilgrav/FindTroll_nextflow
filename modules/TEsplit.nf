#!/usr/bin/env nextflow

/* 
module to split file into respective TE types
*/

process run_split{
    input:
    path(annotated_vcf)

    output:
 //   path("${bam.baseName}.ALU.vcf") emit: alu_out
    path '${bam.baseName}.*.vcf' into dbquery

    script:
    """
    python xx.py
    """ 
}