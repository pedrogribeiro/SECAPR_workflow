# SECAPR Phylogenetics Pipeline

This repository provides a workflow for assembling genomic reads into contigs, extracting and aligning target loci from these assembled contigs, and performing phylogenetic inference. In this case, 
the whole workflow was aimed to work with Lepidotera and, more especifically, butterfly data. You can find further information at Ribeiro, P. G., Torres Jiménez, M. F., Andermann, T., Antonelli, A., Bacon, C. D., & Matos-Maraví, P. (2021). A bioinformatic platform to integrate target capture and whole genome sequences of various read depths for phylogenomics. Molecular Ecology, 30, 6021–6035. https://doi.org/10.1111/mec.16240
The workflow is based on and uses the SECAPR v2.2.3 pipeline (Andermann et al., 2018; Ribeiro et al., 2021)

It supports two assembly strategies:
- **ABySS** (single k-mer per run)
- **SPAdes** (multi k-mer per run)

The workflow is designed for execution on HPC systems using PBS, which differs significantly compared to SLURM.

---

## Workflow Overview

1. **Assembly** (SECAPR)
   - ABySS or SPAdes

2. **Target Extraction** (SECAPR)
   - Identification of loci from assembled contigs using protein coding genes a reference

3. **Alignment** (SECAPR)
   - Across-sample locus alignment - total extracted contigs alignment

4. **Exon trimming** (MAFFT)
   - Per-locus alignment against curated references to keep only intronic regions

5. **Alignment Processing**
   - Cleaning, gap handling, and concatenation

6. **Partitioning**
   - PartitionFinder

7. **Phylogenetic Inference**
   - IQ-TREE2

---

## Repository Structure

The repository contains three main folders:

docs/
resources/
scripts/

In docs and resources you will find the necessary auxiliary files and in scripts you will find the main scripts. For instance, docs contains:
**All_loci_consensus_sequences_v2.fasta**: file with curated proteing coding genes for these analysis, used for extraction (as reference)
**curatedButterflyReferenceGenes.tar.gz**: the same genes, but split into different files to be used as reference for MAFFT, so that it keeps only these intronic regions in the alignment. 
**partition_finder.cfg**: example of how a config file from partition finder looks.

Where to use these files will be identifiable in their respective scripts.


Scripts is further divided in:

abyss/
helpers/
phylogenetics/
spades/

Each one containing the relevant script. Since **spades** and **abyss** correspond to two different strategies, they have very similar scripts, but considering their own contexts. 

## Requirements
The workflow expects you or your cluster to have these programs installed.
SECAPR itself can be used installed with mambaforge or other conda manager. I simply install it as a conda env with:

mamba create -p path/to/yourLocal/software/secaprDir -c bioconda secapr

SECAPR (conda)
MAFFT
IQ-TREE2
PartitionFinder
seqkit
