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
    read_table2() 

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
    
    # Times and Intensities are given as comma seperated concatenated 
    # variables, we will nest them, then create a table by splitting
    # on the comma, done in a nest & map 
    # > d_trc[1,c('Times','Intensities')]
    # # A tibble: 1 x 2
    # Times                                                Intensities                                           
    # <chr>                                                <chr>                                                 
    # 0.008033333,0.02583333,0.04363333,0.06143333,0.0792~ 1.071053,1.023963,0.9768152,0.8999585,1.019606,0.8278~
    nest(c(Times, Intensities)) %>%
    mutate(mrm_trace = map(data, trace_to_tibble)) %>%
    
    # remove data as it is the nested Times+Intensity character
    # strings, where mrm_data is the formatted table of "data"
    select(-data)


saveRDS(d_trc, "./data/rds/samples_1-8_heavy-light_traces.rds")