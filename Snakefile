"""
Run selective sweep simulations :)
"""

import numpy as np
import os, sys, glob

output_dir = 'out/'



"""
test parameters
S_coef = [0.1]
Nws = [10]
Replicates = [0, 1]
"""

S_coef = np.logspace(-5, -1, 5) # selection coefficients
Nws = np.logspace(0.75, 3, 10) # wright neighborhood size
Replicates = np.arange(100)

# calculate sigma values for given neighborhood size, given K=5
Rho = 5
def getSigma(NW):
    return np.sqrt(float(NW)/(4 *  np.pi * Rho))

rule all:
    input: expand( output_dir + 'sim_{REP}_s_{S_COEF}_Nw_{NW}_sweep.trees', REP=Replicates, S_COEF=S_coef, NW=Nws ),
            'spatial_sweep_summary.txt'

rule slimulate:
    output: 
        output_dir + 'sim_{REP}_s_{S_COEF}_Nw_{NW}_sweep.trees'
    params:
        sigma = lambda wc: getSigma(wc.get("NW")),
        outfile = output_dir + 'sim_{REP}_s_{S_COEF}_Nw_{NW}_sweep'
    conda: 'SLiM'
    resources:
        runtime=5000
    shell:
        #thanks silas
        "slim -d SI={params.sigma} -d SM={params.sigma} -d SD={params.sigma} -d S={wildcards.S_COEF}  -d OUTPATH=\\'{params.outfile}\\'  recipes/spatial_sweep.slim"

rule condense:
    input: expand( output_dir + 'sim_{REP}_s_{S_COEF}_Nw_{NW}_sweep.trees', REP=Replicates, S_COEF=S_coef, NW=Nws )
    output: 'spatial_sweep_summary.txt'
    conda: 'rspatial'
    resources:
        runtime=500,
        mem_mb=200000
    shell:
        "Rscript scripts/condense_sims.R"
