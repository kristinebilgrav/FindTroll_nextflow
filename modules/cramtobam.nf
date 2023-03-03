#!/usr/bin/env nextflow

/*

cram to bam
*/

process cramtobam {
    tag "${SampleID}:CramToBam"
 
    input:
    tuple val(SampleID),file(cram), file(crai)


    output:
    tuple val(SampleID), file("${cram.baseName}.bam"), file("${cram.baseName}.bam.bai")


    script:
    """
    samtools view -@ ${task.cpus} -b -h -T ${params.ref_fasta} ${cram} > ${cram.baseName}.bam
    samtools index -@ ${task.cpus} ${cram.baseName}.bam
    """



}