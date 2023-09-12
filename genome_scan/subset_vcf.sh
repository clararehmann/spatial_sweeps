#!/bin/bash
#SBATCH --account=kernlab
#SBATCH --partition=kern,kerngpu
#SBATCH --job-name=tab
#SBATCH --output=tab.out
#SBATCH --error=tab.err
#SBATCH --nodes=1
#SBATCH --mem=100G
#SBATCH --time=10:00:00

chr=$1
startwindow=$2
stopwindow=$3
module purge
module load easybuild  GCC/4.9.3-2.25  OpenMPI/1.10.2
module load HTSlib/1.6
tabix -h gamb.$chr\.phased.n1470.derived.ann.vcf.gz $chr\:$startwindow\-$endwindow > tmp.vcf
