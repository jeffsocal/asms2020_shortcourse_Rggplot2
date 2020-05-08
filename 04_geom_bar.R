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


p_trc <- d_trc %>% 
    mutate(IsotopeLabelType = fct_reorder(IsotopeLabelType, desc(IsotopeLabelType))) %>%
    ggplot(aes(Replicate, TotalArea)) + 
    geom_bar(aes(fill = IsotopeLabelType), 
             stat = 'identity',
             position = 'dodge') + 
    scale_fill_brewer(palette="Set1") +
    ggtitle("IEAIPQIDK GST-tag", "Replicate Comparison") 

p_trc_fct <- p_trc +
    facet_wrap(~FragmentIon, scales="free_y", nrow=1) 



# Challenge
## 1 - use facet_grid to make a matrix of transitions by isotope-label
## 2 - add a 'grey' smoothed line behind each trace without the confidence interval
## 3 - use a custom color scheme


# save plots
pdf(file = "./plots/04_replicate-comparison.pdf", pointsize = 8, width = 5, height = 4)
plot(p_trc)
dev.off()

pdf(file = "./plots/04_replicate-comparison_by-transition.pdf", pointsize = 8, width = 8, height = 4)
plot(p_trc_fct)
dev.off()