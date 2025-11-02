include { trim_Galore} from '../modules/trim_with_trimGalore.nf'

workflow TRIM {
    take:
        input_fastq_ch 
        main:
        trim_output = trim_Galore(
                input_fastq_ch)
    emit:
    trimmed_fastqs = trim_output.trimmed_fastqs
     // emit to the samplesheet channel, use as input for other downstream processes
}