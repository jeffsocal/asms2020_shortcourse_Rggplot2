# ASMS Short Course R::ggplots
# Jeff Jones
# 2020-04-21

library(tidyverse)

# clean out existing variable objects
rm(list=ls())

# CALIBRATION DATA #####################
# read in data
d_cal <- "./data/raw/samples_1-8_heavy-light_calibration.csv" %>% 
    read_csv()

# normalize column names
col_names <- colnames(d_cal)
col_names <- gsub(" ", "_", col_names)

colnames(d_cal) <- col_names

# extract normalized area
d_cal <- d_cal %>%
    separate(
        Quantification, sep=": ", into=c("Quant_Label", "Quant_Value"),
        convert = TRUE
    )

saveRDS(d_cal, "./data/rds/samples_1-8_heavy-light_calibration.rds")


# TRACES DATA ##########################
d_trc <- "./data/raw/samples_1-8_heavy-light_traces.tsv" %>% 
    read_table2() %>%
    nest(c(Times, Intensities))

# normalize column names
col_names <- colnames(d_trc)
col_names <- gsub(" ", "_", col_names)

colnames(d_trc) <- col_names

# function mapping trace data to tibble
trace_to_tibble <- function(d_list){
    
    times <- d_list$Times %>% str_split(",")
    inten <- d_list$Intensities %>% str_split(",")
    
    return(
        tibble(
            times = times[[1]] %>% as.numeric(),
            intensities = inten[[1]] %>% as.numeric()
        )
    )
    
}

# map the function 
d_trc <- d_trc %>%
    separate(FileName, sep = "[\\.|\\_]", into=c('STD','Replicate','Raw'), remove = F) %>%
    select(-c('STD','Raw')) %>%
    mutate(Replicate = as.numeric(Replicate)) %>%
    mutate(mrm_trace = map(data, trace_to_tibble)) %>%
    select(-data)


saveRDS(d_trc, "./data/rds/samples_1-8_heavy-light_traces.rds")