version 1.0

workflow BaseRecalibrator {

  input {
    # Required Arguments
    Array[File] input_bam
    Array[File] input_bam_index
    Array[File] known_sites
    Array[File] known_sites_index
    File reference
    File reference_index
    File reference_dict
    String output_bqsr_table = "recal.table"

    # Runtime
    Int memory_gb = 16
    Int disk_gb = 200
    Int cpu = 4
    Int preemptible = 1
  }

  call RunBaseRecalibrator {
    input:
      input_bam           = input_bam,
      input_bam_index     = input_bam_index,
      known_sites         = known_sites,
      known_sites_index   = known_sites_index,
      reference           = reference,
      reference_index     = reference_index,
      reference_dict      = reference_dict,
      output_bqsr_table   = output_bqsr_table,
      memory_gb           = memory_gb,
      disk_gb             = disk_gb,
      cpu                 = cpu,
      preemptible         = preemptible
  }

  output {
    File recal_table = RunBaseRecalibrator.recal_table
  }
}

task RunBaseRecalibrator {

  input {
    Array[File] input_bam
    Array[File] input_bam_index
    Array[File] known_sites
    Array[File] known_sites_index
    File reference
    File reference_index
    File reference_dict
    String output_bqsr_table

    Int memory_gb
    Int disk_gb
    Int cpu
    Int preemptible
  }

  command <<<
    set -euo pipefail

    gatk BaseRecalibrator \
      --input ~{sep=' --input ' input_bam} \
      --known-sites ~{sep=' --known-sites ' known_sites} \
      --output ~{output_bqsr_table} \
      --reference ~{reference}
  >>>

  runtime {
    docker:      "broadinstitute/gatk:4.6.2.0"
    memory:      "~{memory_gb} GB"
    disks:       "local-disk ~{disk_gb} HDD"
    cpu:         cpu
    preemptible: preemptible
  }

  output {
    File recal_table = output_bqsr_table
  }
}
