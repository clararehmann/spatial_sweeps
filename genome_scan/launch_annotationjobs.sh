#!/bin/bash

for chrom in 2L 2R 3L 3R X; do
    sbatch snpeffects.batch $chrom
done
