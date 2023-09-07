suppressMessages(suppressWarnings(require(data.table)))
suppressMessages(suppressWarnings(require(scales)))
suppressMessages(suppressWarnings(require(raster)))
suppressMessages(suppressWarnings(require(sp)))
suppressMessages(suppressWarnings(require(MASS)))
suppressMessages(suppressWarnings(require(rgeos)))
suppressMessages(suppressWarnings(require(plyr)))
suppressMessages(suppressWarnings(require(progress)))
suppressMessages(suppressWarnings(require(argparse)))
suppressMessages(suppressWarnings(require(ggplot2)))
suppressMessages(suppressWarnings(require(tidyverse)))

process_sim <- function(log) {

    #read and process csv from input path sim_REP_s_SCOEF_Nw_NW_og

    # get parameters
    params <- str_split(log, '_')[[1]]
    rep <- as.numeric(params[2])
    scoef <- as.numeric(params[4])
    nw <- as.numeric(params[6])
   
    df <- fread(log)
    colnames(df) <- c('tick','pop_size','allele_freq','mean_fitness','allele_distance','mean_age')
    # set allele appearance as time 0
    df$allele_freq <- as.numeric(df$allele_freq)
    start <- last(which(is.na(df$allele_freq)))
    df <- df[start:nrow(df),]
    df$tick <- df$tick - df$tick[1]
    # standardize allele distance between 0 and 1
    df$allele_distance <- as.numeric(df$allele_distance)
    df$allele_distance <- rescale(df$allele_distance)
    # add parameters to dataframe
    df$rep <- rep
    df$scoef <- scoef
    df$nw <- nw

    return(df)
    }

options(warn=2)

directory = "out/"
unf <- Sys.glob(paste0(directory, '*.log'))
df <- process_sim(unf[1])
for (f in unf[2:length(unf)]){
    pd <- process_sim(f)
    df <- rbind(df, pd)
}

summary <- df %>% group_by(scoef, nw, tick) %>% summarize(allele_freq = mean(allele_freq, na.rm = TRUE),
                                         allele_distance = mean(allele_distance, na.rm = TRUE))

summary <- summary %>% ungroup()

summary[is.na(summary$allele_freq),]$allele_freq <- 0
summary[is.na(summary$allele_distance),]$allele_distance <- 0

      
write.table(df, 'spatial_sweep_all_sims.txt', sep='\t', row.names=FALSE)
write.table(summary, 'spatial_sweep_summary.txt', sep='\t', row.names=FALSE)
