process  multiqc {
    // FastQC quality control for sequencing reads
    cache "deep";
    
    input:
        file(fastqcs)
    output:
        path("multiQC_report*")

    when:
    task.ext.when == null || task.ext.when

    script:
    """
     multiqc -f -o . -n multiQC_report.html *.zip
    """
}