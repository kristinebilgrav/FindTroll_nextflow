#!/usr/bin/env nextflow

/* 
module to split file into respective TE types
*/

process run_split{
    input:
    path vcf from run_retro_call

    output:
    path("${bam.baseName}.ALU.vcf") emit: alu_out
    path("${bam.baseName}.L1.vcf") emit: l1_out
    path("${bam.baseName}.HERV.vcf") emit: herv_out
    path("${bam.baseName}.SVA.vcf") emit: sva_out

    script:
    """
    python xx.py
    """ 
}