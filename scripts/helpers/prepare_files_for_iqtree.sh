#!/bin/bash
# Purpose: prepare MAFFT-aligned locus files for downstream concatenation and IQ-TREE analysis.
# Note: this script should be run in the directory containing the MAFFT output files.

##### remove consensus sequence from fasta files #####
for file in *.fasta; do
    sed '/>P/{N;d;}' "./${file}" > "./${file%%.*}.fas"
done

##### remove original fasta files #####
rm *.fasta

##### remove empty lines #####
sed -i '/^$/d' *.fas

##### remove non-fasta files from subdirectories #####
find ./*/ -type f ! -name '*.fasta' -delete

##### remove empty lines from fasta files in subdirectories #####
for file in */*.fasta; do
    sed -i '/^\s*$/d' "./${file}"
done

##### remove empty files in subdirectories #####
find . -empty -type f -delete

##### change voucher names #####
# Note: only do this if really needed/you need to change sample names in alignments. If you did not use SECAPR for assembly it might not be needed
#for file in *.fas; do
#    seqkit replace -p "(.+)" -r '{kv}' -k ./taxon_list.txt "./${file}" > "./${file%%.*}.fasta"
#done

##### remove intermediate fas files #####
rm *.fas

##### change gap characters to N #####
for file in *.fasta; do
    sed -i '/^>/!y/-/N/' "./${file}"
done

##### add missing sequences with secapr #####
module load mambaforge
mamba activate secapr_env
secapr add_missing_sequences --input . --output ./secaprAddMissing

##### concatenate sequences for iqtree #####
# Note: the partitions file can be used to generate a file that will be used in Partition Finder, if you use it. concatenated.phy is your final alignment. 
cd ./secaprAddMissing || exit 1
~/software/catfasta2phyml/catfasta2phyml.pl *.fasta > concatenated.phy 2> partitions.txt
