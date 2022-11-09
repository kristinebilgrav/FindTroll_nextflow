#!/usr/bin/env nextflow

/* 
Frq and gene list filter
*/


process filter_rank {
    publishDir params.output, mode: 'copy'

    input:
    path(all_calls)

    output:
    path "${all_calls.baseName}.clean.vcf", emit: all_calls_clean

    script:
    """
    python ${params.FindTroll_home}/scripts/filter_rank.py ${all_calls} ${all_calls.baseName}.clean.vcf
    """
}

process gene_list_filter {
    publishDir params.output, mode: 'copy'

    input:
    path(all_calls_clean)

    output:
    path "${all_calls_clean.baseName}.genes.vcf", emit: all_calls_genes

    script:
    """
    python ${params.FindTroll_home}/scripts/find_genes.py ${params.gene_list} ${all_calls_clean} ${all_calls_clean.baseName}.genes.vcf
    """

}