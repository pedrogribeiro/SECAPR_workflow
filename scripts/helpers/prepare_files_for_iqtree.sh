#!/bin/bash
# Purpose: prepare MAFFT-aligned locus files for downstream concatenation and IQ-TREE analysis.
# Note: this script should be run in the directory containing the MAFFT output files.

# Transform fasta in one-line fastas, change file extension to .fas to avoid losing info
for file in *.fasta; do awk 'NR==1 {printf("%s\n", $0); next} /^>/ {printf("\n%s\n",$0); next; } { printf("%s",$0);} END {printf("\n");}' "$file" > "${file%%.*}.fas"; done

# delete the unchanged fasta
rm *.fasta

# Alignments come with headers (P1, P2, etc) that should not be in the concatenated aligment. Remove them
for file in *.fasta; do sed '/>P/,/^/d' < "./""$file" > "./""${file%%.*}"".fasta"; done

# In case the previous generates empty lines or files, delete those.
for file in *.fasta; do sed -i '/^\s*$/d' "./""$file"; done
find . -empty -type f -delete

# Moving on to changing "-" for "N"
for file in *.fasta; do sed -i '/^>/!y/-/N/' "./""$file"; done

# Concatenation does not allow missing sequences, so we need to add them even if they are supposed to be only "Ns". Secapr can do this.
module load mambaforge
mamba activate /storage/plzen1/home/pedroribeiro/Software/secapr_env
mkdir secaprAddMissing
secapr add_missing_sequences --input . --output ./secaprAddMissing

##### concatenate sequences for iqtree #####
# Note: the partitions file can be used to generate a file that will be used in Partition Finder, if you use it. concatenated.phy is your final alignment. 
source ~/.bashrc
catfasta2phyml.pl --sequential *.fasta > ButtConcatenated.phy 2> partitions.txt
