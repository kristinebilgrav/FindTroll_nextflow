#!/usr/bin/env nextflow

/* 
module to split file into respective TE types
*/

process run_split {
    tag "${SampleID}:SplitOnTE"

    input:
    tuple val(SampleID) , file(annotated_vcf)

    output:
    tuple val(SampleID), file("${annotated_vcf.baseName}.*.vcf")

    script:
    """
    python ${params.working_dir}/scripts/splitTEs.py  ${annotated_vcf.baseName} ${annotated_vcf}
    """ 
}