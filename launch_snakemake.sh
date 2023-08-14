#!/bin/bash

snakemake --unlock
snakemake --profile slurm --conda-frontend conda --use-conda --keep-going --rerun-incomplete --latency-wait 1 $1
