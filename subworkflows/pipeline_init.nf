workflow PIPELINE_INIT {
    take:
    //  path to the input samplesheet .csv file, the sampleshet file should contain the columns SampleID, FASTQ1, and FASTQ2
    //  other format will not be accepted. 
    // Please modify your sampleshete file accordingly.
    //  The FASTQ1 and FASTQ2 columns should contain the path to the fastq files.
    //  The SampleID column should contain the sample ID. The SampleID will be used later in all downstream processes. 
        input_SampleSheet 
    main:
        Channel
        .fromPath(input_SampleSheet)
        .splitCsv(header: true)
        .map { row -> tuple(row.SampleID, file(row.FASTQ1), file(row.FASTQ2))}
        .set{input_fastq_ch}
    
    emit:
    samplesheet = input_fastq_ch // emit to the samplesheet channel, use as input for other downstream processes
}