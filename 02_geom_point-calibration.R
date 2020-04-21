# ASMS Short Course R::ggplots
# Jeff Jones
# 2020-04-21

library(tidyverse)
library(ggplot2)

# clean out existing variable objects
rm(list=ls())

# set the theme to black-white (remove grey plot area)
theme_set(theme_bw())

# read in data
d_cal <- "./data/rds/samples_1-8_heavy-light_calibration.rds" %>% 
    read_rds()

# plot x axis is a character 
d_cal %>% 
    ggplot(aes(replicate, quant_value)) + 
    geom_point()

# plot x axis is now a numeric
d_cal %>%
    filter(replicate != "FOXN1-GST") %>%
    mutate(replicate = as.numeric(replicate)) %>%
    ggplot(aes(replicate, quant_value)) + 
    geom_point()
