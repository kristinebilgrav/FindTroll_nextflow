#!/usr/bin/env nextflow

/* 
Frq and gene list filter
*/


process filter_rank {
    tag "${SampleID}:Filter"
    publishDir "${params.output}/${SampleID}_out/", mode: 'copy'

    input:
    tuple val(SampleID), file(all_calls)

    output:
    tuple val(SampleID), file("${all_calls.baseName}.clean.vcf")

    script:
    """
    python ${params.FindTroll_home}/scripts/filter_rank.py ${all_calls} ${all_calls.baseName}.clean.vcf
    """
}

process gene_list_filter {
    tag "${SampleID}:GeneListFilter"
    publishDir "${params.output}/${SampleID}_out/", mode: 'copy'

    input:
    tuple val(SampleID), file(all_calls_clean)

    output:
    tuple val(SampleID), file("${all_calls_clean.baseName}.genes.vcf")

    script:
    """
    python ${params.FindTroll_home}/scripts/find_genes.py ${params.gene_list} ${all_calls_clean} ${all_calls_clean.baseName}.genes.vcf
    """

}