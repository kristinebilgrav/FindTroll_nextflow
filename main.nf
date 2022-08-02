#!/usr/bin/env nextflow

/*
main pipeline script
*/

nextflow.enable.dsl = 2


bams = Channel.fromPath(params.in)
params.config=""
parmas.outdir = "results"

log.info """\
FindTroll pipeline
------------------
sample(s) : ${bams}
outdir :  ${params.outdir}

"""
// include modules

include { RetroSeq } from './modules/RetroSeq'
include {annotate} from './modules/annotate'

// main script flow
workflow{

    RetroSeq(params.bam) 
    annotate(RetroSeq.out)
}


//split ?

//ALU database

//L1 database

//SVA database

//HERV database



//filter/rank


//completion handler
workflow.onComplete {
    log.info (workflow.success ? "Done, Trolls found!" : "Failed, did sun come too soon? :(")
}