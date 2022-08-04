#!/usr/bin/env nextflow

/*
main pipeline script
*/

nextflow.enable.dsl = 2


log.info """\
FindTroll pipeline
------------------
config: ${params.config}
sample(s) : ${params.bam}
outdir :  ${params.outdir}

"""

// include modules
include { run_retro_discover } from './modules/RetroSeq'
include {run_vep} from './modules/annotate'

// main script flow
workflow RetroSeq {

    take: bam
    main: 
        run_retro_discover(bam)
        run_retro_call(run_retro_discover.out)
    emit:
        called_vcf

}


workflow{
    call = Channel.fromPath('results/*called.out')
    run_retro_discover() 
    run_retro_call(call)
    annoteted = Channel.fromPath('results/*.called.VEP.vcf')
    run_vep(annotated)
}


//split ?

//ALU database

//L1 database

//SVA database

//HERV database



//filter/rank


//completion handler
workflow.onComplete {
    log.info (workflow.success ? "Done, trolls found and captured in results!" : "Failed, did the sun come too soon and turn the troll to stone? :(")
}