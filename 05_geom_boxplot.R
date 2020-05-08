# ASMS Short Course R::ggplots
# Jeff Jones
# 2020-04-21

library(tidyverse)
library(ggplot2)

# clean out existing variable objects
rm(list=ls())

# set the theme to black-white (remove grey plot area)
theme_set(theme_bw())

d_cal <- "./data/rds/samples_1-8_heavy-light_calibration.rds" %>% readRDS()

# read in data
d_trc <- "./data/rds/samples_1-8_heavy-light_traces.rds" %>% 
    read_rds() %>%
    separate(FileName, sep = "[\\.|\\_]", into=c('STD','Replicate','Raw')) %>%
    select(-c('STD','Raw')) %>%
    inner_join(d_cal, by='Replicate') %>%
    mutate(Replicate = as.numeric(Replicate))


p_box <- d_trc %>%
    mutate(IsotopeLabelType = fct_reorder(IsotopeLabelType, desc(IsotopeLabelType))) %>%
    ggplot(aes(FragmentIon, TotalArea)) + 
    geom_boxplot(aes(fill = IsotopeLabelType)) + 
        scale_y_log10() +
    scale_fill_brewer(palette="Set1") +
    ggtitle("IEAIPQIDK GST-tag", "Replicate Comparison") 

p_box_fct <- p_box +
    facet_wrap(~FragmentIon, scales="free") 

# save plots
pdf(file = "./plots/05_geom_boxplot.pdf", pointsize = 8, width = 5, height = 4)
plot(p_box)
dev.off()

pdf(file = "./plots/05_geom_boxplot_by-transition.pdf", pointsize = 8, width = 8, height = 4)
plot(p_box_fct)
dev.off()