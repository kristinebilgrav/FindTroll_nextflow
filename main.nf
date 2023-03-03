#!/usr/bin/env nextflow

/*
main pipeline script
*/

nextflow.enable.dsl = 2


log.info """\
FindTroll pipeline
------------------
sample(s) : ${params.input}
output directory :  ${params.output}

"""

 
 // include modules
if ( params.input.endsWith('csv') ) { 
    Channel
        .fromPath(params.input)
        .splitCsv(header: true)
        .map{ row ->  tuple(row.SampleID, file(row.SamplePath), file(row.SamplePath.tokenize('.')[0]+'*.*ai'))  }
        .set{sample_channel}
    
}

else {
    String path = params.input 
    SampleID = path.tokenize('/')[-1].tokenize('.')[0]
    Channel
        .fromPath(params.input) 
        .map{tuple(SampleID, file(params.input), file(params.input.tokenize('.')[0]+'*.*ai') )}
        .set{sample_channel}

}
if (params.file == 'cram') {
    include { cramtobam } from './modules/cramtobam'
}

include { run_retro } from './modules/RetroSeq'
include { run_delly ; bcf_to_vcf ; MobileAnn } from './modules/delly'
include {  run_vep } from './modules/annotate'
include { run_split } from './modules/TEsplit'
include { query } from './modules/dbquery'
include { svdb_merge ; merge_calls } from  './modules/combine'
include { filter_rank } from './modules/filter'

def file = new File(params.gene_list)
if (file.exists()) {
    include { gene_list_filter } from './modules/filter'
}



workflow retro{
    take: sample_channel

    main: 
    if (params.file == 'cram') {
        bam_bai_channel = cramtobam(sample_channel)
    }
    else {
        bam_bai_channel =sample_channel
    }
 
    run_retro(bam_bai_channel) 

    run_vep(run_retro.out)
    run_split(run_vep.out.annotated_vcf) 

    query(run_split.out.flatten())

    tomerge = Channel.fromPath("${params.output}/*.query.vcf").collect()
    merge_calls(tomerge)
    filter_rank(merge_calls.out)

    if (file.exists()) {
        gene_list_filter(filter_rank.out)
    }

}

workflow wdelly {
    if (params.file == 'cram') {
        bam_bai_channel = cramtobam(sample_channel)
    }
    else {
        bam_bai_channel =sample_channel
    }
 
    run_retro(bam_bai_channel) 
    run_delly(bam_bai_channel)
    bcf_to_vcf(run_delly.out)

    delly_annotate_ch = bcf_to_vcf.join(run_retro.out)
    MobileAnn(bcf_to_vcf.out)

    merge_ch = run_retro.out.join(MobileAnn.out) //join
    
    svdb_merge(merge_ch)


    run_vep(svdb_merge.out)
    run_split(run_vep.out.annotated_vcf) 

    query(run_split.out.flatten())

    tomerge = Channel.fromPath("${params.output}/*.query.vcf").collect()
    merge_calls(tomerge)
    filter_rank(merge_calls.out)

    if (file.exists()) {
        gene_list_filter(filter_rank.out)
    }

}

workflow {
    main:
    retro(sample_channel)

}

//completion handler
workflow.onComplete {
    log.info (workflow.success ? "Done, trolls found and captured in ${params.output}!" : "Failed, did the sun come too soon and turn the troll to stone? :(")
}