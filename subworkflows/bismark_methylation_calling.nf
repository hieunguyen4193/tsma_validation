
include { bismark_alignment as main_bismark } from "../modules/bismark_align.nf"
include { bismark_methylation_extractor } from "../modules/bismark_methylation_extractor.nf"

// Define workflow to subset and index a genome region fasta file
workflow ALIGNMENT_AND_METHYLATION_CALLING {
    take:
        input_fastq_ch
        BismarkIndex
    main:
        bismark_bam = main_bismark(input_fastq_ch, BismarkIndex)
        methyl_density = bismark_methylation_extractor(bismark_bam)

    emit:
        methyl_density_ch = methyl_density       
}