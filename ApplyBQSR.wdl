version 1.0

workflow ApplyBQSR {

  input {
    # Required Arguments
    Array[File] input_bam
    Array[File] input_bam_index
    File bqsr_recal_file
    File reference
    File reference_index
    File reference_dict
    String output_bam = "applyRecalibration.bam"

    # Runtime
    Int memory_gb = 32
    Int disk_gb = 200
    Int cpu = 4
    Int preemptible = 1
  }

  call RunApplyBQSR {
    input:
      input_bam       = input_bam,
      input_bam_index = input_bam_index,
      bqsr_recal_file = bqsr_recal_file,
      reference       = reference,
      reference_index = reference_index,
      reference_dict  = reference_dict,
      output_bam      = output_bam,
      memory_gb       = memory_gb,
      disk_gb         = disk_gb,
      cpu             = cpu,
      preemptible     = preemptible
  }

  output {
    File recalibrated_bam     = RunApplyBQSR.recalibrated_bam
  }
}

task RunApplyBQSR {

  input {
    Array[File] input_bam
    Array[File] input_bam_index
    File bqsr_recal_file
    File reference
    File reference_index
    File reference_dict
    String output_bam

    Int memory_gb
    Int disk_gb
    Int cpu
    Int preemptible
  }

  command <<<
    set -euo pipefail

    gatk ApplyBQSR \
      --input ~{sep=' --input ' input_bam} \
      --reference ~{reference} \
      --bqsr-recal-file ~{bqsr_recal_file} \
      --create-output-bam-index false \
      --output ~{output_bam}
  >>>

  runtime {
    docker:      "broadinstitute/gatk:4.6.2.0"
    memory:      "~{memory_gb} GB"
    disks:       "local-disk ~{disk_gb} HDD"
    cpu:         cpu
    preemptible: preemptible
  }

  output {
    File recalibrated_bam = output_bam
  }
}
