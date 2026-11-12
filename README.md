# baserecalibrator

# BaseRecalibrator (GATK 4.6.2.0)

## Overview
GATK BaseRecalibrator를 Terra에서 실행하기 위한 WDL 워크플로우

## GATK Version
- `broadinstitute/gatk:4.6.2.0`

## Inputs
| Parameter | Type | Description |
|---|---|---|
| input_bam | Array[File] | BAM 파일 |
| known_sites | Array[File] | dbSNP, Mills 등 VCF |
| reference | File | hg38 reference fasta |

## Known Sites (hg38 권장)
- dbsnp138
- Mills_and_1000G_gold_standard.indels
- Homo_sapiens_assembly38.known_indels

## Output
- `recal.table` — ApplyBQSR 단계에서 사용할 recalibration table
