/*
 * Alignment with Cellranger
 */

include { fastqc } from "../modules/fastqc.nf"
include { multiqc } from "../modules/multiqc.nf"

// Define workflow to subset and index a genome region fasta file
workflow FASTQ_QC {
    take:
        input_fastq_ch 
    main:
        fastqc_outputs = fastqc(input_fastq_ch)
        multiqc( fastqc_outputs.fastqc_zip.collect() )
}