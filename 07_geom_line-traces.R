# ASMS Short Course R::ggplots
# Jeff Jones
# 2020-04-21

library(tidyverse)
library(ggplot2)

# clean out existing variable objects
rm(list=ls())

# set the theme to black-white (remove grey plot area)
theme_set(theme_bw())

# read in calibration data (use for labeling)
d_cal <- "./data/rds/samples_1-8_heavy-light_calibration.rds" %>% readRDS()

# read in data
d_trc <- "./data/rds/samples_1-8_heavy-light_traces.rds" %>% 
    read_rds() %>%
    separate(filename, sep = "[\\.|\\_]", into=c('std','replicate','raw')) %>%
    select(-c('std','raw')) %>%
    # merge in calibration data
    inner_join(d_cal, by='replicate')

d_trcs <- d_trc %>% unnest(mrm_trace)

d_trcs %>% 
    filter(abs(times - 21) < 2) %>%
    ggplot(aes(times, intensities)) +
    geom_line(aes(color=isotopelabeltype)) +
    scale_color_brewer(palette="Set1") +
    facet_wrap(fragmention~replicate, scales = 'free', ncol=8)

d_frg <- "./data/raw/abs_quant_trans-list.csv" %>% 
    read_csv(col_names = c('precursormz', 
                           'productmz',
                           'peptide_rt_expect',
                           'peptide',
                           'protein',
                           'fragmention',
                           'blank',
                           'isotopelabeltype'))
