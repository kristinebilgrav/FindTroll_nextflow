#!/usr/bin/env nextflow

/*
module to run RetroSeq

*/
nextflow.enable.dsl = 2

// can be run using --in 'dataset/*.fa'


//create output channels
//queue channels (connecting several processes)

filter = Channel.fromPath('filter/output')



#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
Run retroseq - calling of Trolls (TRanspOsabLe eLementS)
*/


//run RetroSeq
process run_retro_discover {
  publishDir params.outdir, mode:'copy'
  errorStrategy 'ignore'
  tag {vcf_file}

  cpus 2
  memory ''

  input:
  file(bam_files) 

  output:
  path "${bam_file.baseName}.vcf" into publishDir

  script:
  """
  singularity exec ${params.FindTroll_home}/FindTroll.sif retroseq.pl -discover -bam ${bam_file} -output ${{bam_file.baseName}.vcf} -refTEs ${params.ref_ME_tab}
  """

}

process run_retro_call {
  publishDir "${params.working_dir}", mode: 'copy', overwrite: true
  errorStrategy 'ignore'
  tag {vcf_file}

  cpus 2

  input:
  file(bam_file), file x from run_retro_discover //how to get the name connected?

  output:
  path "${bam_file.baseName}.final.vcf" into publishDir

  script:
  """
  singularity exec ${params.FindTroll_home}/FindTroll.sif retroseq.pl -call -bam ${bam_file} -input ${discover_vcf}   -ref ${params.ref_fasta}  -output ${{bam_file.baseName}.final.vcf}
  """

}


