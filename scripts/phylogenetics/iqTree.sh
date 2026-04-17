#!/bin/bash
# Purpose: run IQ-TREE on Wolbachia concatenated alignment with partition file.
# Note: this is an HPC/PBS example and paths should be adapted to the local system.

##### pbs settings #####
#PBS -N iqtree_wolbachia
#PBS -l select=1:ncpus=4:mem=12gb:scratch_local=30gb
#PBS -l walltime=95:59:00
#PBS -o /storage/plzen1/home/pedroribeiro/Projects/Eudaminae_MacroWolbachia/scripts/newAnalyses/iqtree/iqtree2/out/iqtree_wolbachia.txt
#PBS -e /storage/plzen1/home/pedroribeiro/Projects/Eudaminae_MacroWolbachia/scripts/newAnalyses/iqtree/iqtree2/err/iqtree_wolbachia.txt

##### define variables #####
PROJECT_DIR="/storage/brno12-cerit/home/pedroribeiro/Projects/Eudaminae_MacroWolbachia/newAnalyses/iqtree"
OUTPUT_DIR="/storage/brno12-cerit/home/pedroribeiro/Projects/Eudaminae_MacroWolbachia/newAnalyses/iqtree/newTrees_23-12"

INPUT="${PROJECT_DIR}/wolbConcatenatedAB.phy"
PARTITIONS="${PROJECT_DIR}/partitions.txt"
PREFIX="124WolbGenes"


THREADS="4"

##### system specific definitions #####
trap 'clean_scratch' TERM EXIT
cd "$SCRATCHDIR" || exit 1
export TMPDIR="$SCRATCHDIR"

##### activate environment #####
source /storage/plzen1/home/pedroribeiro/.bashrc

##### run iqtree #####
iqtree2 \
  -s "$INPUT" \
  -p "$PARTITIONS" \
  --prefix "$PREFIX" \
  -B 1000 \
  --alrt 1000 \
  --boot-trees \
  --wbtl \
  --bnni \
  -T "$THREADS" \
  -m MFP

##### copy output files #####
cp "${PREFIX}"* "$OUTPUT_DIR"
