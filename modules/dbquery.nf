#!/usr/bin/env nextflow

/* 
module to query file against a database
*/

// make seperate to run at the same time?
process ALU_query {
    input:
    path alu_out
    
    output:


    shell:
    """
    singularity exec findtroll.sif svdb --query --query_vcf ${input} --db ${params.alu_vcf} --overlap -1 --bnd_distance 150 > ${{bam.baseName}.ALU.query.vcf}
    """

    else if 'L1' in vcf
        """
        singularity exec findtroll.sif svdb --query --query_vcf ${input} --db ${params.L1_vcf} --overlap -1 --bnd_distance 150 > ${{bam.baseName}.L1.query.vcf}
        """

    else if 'HERV' in vcf
        """
        singularity exec findtroll.sif svdb --query --query_vcf ${input} --db ${params.HERV_vcf} --overlap -1 --bnd_distance 150 > ${{bam.baseName}.HERV.query.vcf}
        """

    else if 'SVA' in vcf
        """
        singularity exec findtroll.sif svdb --query --query_vcf ${input} --db ${params.SVA_vcf} --overlap -1 --bnd_distance 150 > ${{bam.baseName}.SVA.query.vcf}
        """
    
}


