#!/bin/bash
# Purpose: run PartitionFinder on a concatenated alignment using an existing configuration directory. All necessary files must be in the directory.
# Note: this is an HPC/PBS example and paths should be adapted to the local system.

##### pbs settings #####
#PBS -N partitionfinder_nuclear_tree
#PBS -l select=1:ncpus=8:mem=10gb:scratch_local=300gb
#PBS -l walltime=95:59:00
#PBS -o /storage/plzen1/home/pedroribeiro/Projects/Spicauda_PopGen/PBS/out/partitionfinder_nuclear_tree/partitionfinder_nuclear_tree.txt
#PBS -e /storage/plzen1/home/pedroribeiro/Projects/Spicauda_PopGen/PBS/err/partitionfinder_nuclear_tree/partitionfinder_nuclear_tree.txt

##### define variables #####
PROJECT_DIR="/storage/plzen1/home/pedroribeiro/Projects/Spicauda_PopGen"
PARTITIONFINDER_DIR="${PROJECT_DIR}/Scripts/partitionFinder_NuclearTreeOct2023"

THREADS="8"
RCLUSTER_PERCENT="10"

##### system specific definitions #####
trap 'clean_scratch' TERM EXIT
cd "$SCRATCHDIR" || exit 1
export TMPDIR="$SCRATCHDIR"

##### activate environment #####
source /storage/plzen1/home/pedroribeiro/.bashrc
module load partitionfinder

##### run partitionfinder #####
PartitionFinder.py \
  "$PARTITIONFINDER_DIR" \
  --raxml \
  --rcluster-percent "$RCLUSTER_PERCENT" \
  -p "$THREADS"
