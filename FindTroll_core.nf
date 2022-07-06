#!/usr/bin/env nextflow

/*
pipeline core

*/

params.folder = ""
params.bam=""


/*
folder, get prefix of bamfiles
defines a channel (bam_files) with bams in path
which using map will;
apply function and output new channel for each file
*/

if(params.folder){
    print "analysing all bam files in ${params.folder}\n"

    bam_files=Channel.fromPath("${params.folder}/*.bam").map{
        line ->
        ["${file(line).baseName}",file(line)]
	}
}


/*
if bamfile, get and check if all files exists
define channel, map to function and produce new channel
*/

else if(params.bam){
    Channel.from( params.bam.split(",")).subscribe{
        if(!file(it).exists()) exit 1, "Missing bam:${it}, needs bam file to run "
    }
	bam_files=Channel.from(params.bam.split(",")).map{
        line ->
        ["${file(line).baseName}", file(line) ]
	}
    }

//create output channels
//queue channels (connecting several processes)

RetroSeq = Channel.fromPath('{bam_file.baseName}.final.vcf')
filter = Channel.fromPath('filter/output')
annotate = Channel.fromPath('vep/output')


//run RetroSeq
process run_retro_discover {
  publishDir "${params.working_dir}", mode: 'copy', overwrite: true
  errorStrategy 'ignore'
  tag {vcf_file}


  cpus 2

  input:
  file(params.bam) //or bam_file (params.bam to bam_file?)

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
