#!/usr/bin/env nextflow

/*
module to run RetroSeq

*/
nextflow.enable.dsl = 2


bams = Channel.fromPath(params.in)
// can be run using --in 'dataset/*.fa'



//create output channels
//queue channels (connecting several processes)

RetroSeq = Channel.fromPath('{bam_file.baseName}.final.vcf') 
filter = Channel.fromPath('filter/output')
annotate = Channel.fromPath('{bam_file.baseName}.final.VEP.vcf')


//run RetroSeq
process run_retro_discover {
  publishDir "${params.working_dir}", mode: 'copy', overwrite: true
  errorStrategy 'ignore'
  tag {vcf_file}


  cpus 2

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

  input:
  file(bam_file), file x from run_retro_discover //how to get the name connected?

  output:
  path "${bam_file.baseName}.final.vcf" into publishDir

  script:
  """
  singularity exec ${params.FindTroll_home}/FindTroll.sif retroseq.pl -call -bam ${bam_file} -input ${discover_vcf}   -ref ${params.ref_fasta}  -output ${{bam_file.baseName}.final.vcf}
  """

}


//split ?

//ALU database

//L1 database

//SVA database

//HERV database

//VEP
vep_exec = params.VEP_path
process run_vep {
  publishDir "${params.working_dir}", mode: 'copy', overwrite: true

  cpus 1

  input:
  file(vcf_file) from vcf_files

  output:
  path "${bam_file.baseName}.final.VEP.vcf" into publishDir

  """
  ${vep_exec} -i ${vcf_file} -o ${{bam_file.baseName}.final.VEP.vcf} ${params.vep_args}
  """

}

//filter/rank

workflow{

  
}