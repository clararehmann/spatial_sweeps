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
Nws = np.logspace(0, 3, 10) # wright neighborhood size
Replicates = np.arange(100)

# calculate sigma values for given neighborhood size, given K=5
Rho = 5
def getSigma(NW):
    return np.sqrt(float(NW)/(4 *  np.pi * Rho))

rule all:
    input: expand( output_dir + 'sim_{REP}_s_{S_COEF}_Nw_{NW}_sweep.trees', REP=Replicates, S_COEF=S_coef, NW=Nws )

rule slimulate:
    output: 
        output_dir + 'sim_{REP}_s_{S_COEF}_Nw_{NW}_sweep.trees'
    params:
        sigma = lambda wc: getSigma(wc.get("NW")),
        outfile = output_dir + 'sim_{REP}_s_{S_COEF}_Nw_{NW}_sweep'
    conda: 'SLiM'
    shell:
        #thanks silas
        "slim -d SI={params.sigma} -d SM={params.sigma} -d SD={params.sigma} -d S={wildcards.S_COEF}  -d OUTPATH=\\'{params.outfile}\\'  recipes/spatial_sweep.slim"
