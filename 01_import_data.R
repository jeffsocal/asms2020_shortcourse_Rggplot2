# ASMS Short Course R::ggplots
# Jeff Jones
# 2020-04-21

library(tidyverse)
library(ggplot2)

# clean out existing variable objects
rm(list=ls())

# CALIBRATION DATA #####################
# read in data
d_cal <- "./data/raw/samples_1-8_heavy-light_calibration.csv" %>% 
    read_csv()

# normalize column names
col_names <- colnames(d_cal) %>% tolower()
col_names <- gsub(" ", "_", col_names)

colnames(d_cal) <- col_names

# extract normalized area
d_cal <- d_cal %>%
    separate(
        quantification, sep=": ", into=c("quant_label", "quant_value"),
        convert = TRUE
    )

saveRDS(d_cal, "./data/rds/samples_1-8_heavy-light_calibration.rds")


# TRACES DATA ##########################
d_trc <- "./data/raw/samples_1-8_heavy-light_traces.tsv" %>% 
    read_table2() %>%
    nest(c(Times, Intensities))

# normalize column names
col_names <- colnames(d_trc) %>% tolower()
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
    mutate(mrm_trace = map(data, trace_to_tibble)) %>%
    select(-data)

saveRDS(d_trc, "./data/rds/samples_1-8_heavy-light_traces.rds")