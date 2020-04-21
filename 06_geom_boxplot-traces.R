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
    separate(filename, sep = "[\\.|\\_]", into=c('std','replicate','raw')) %>%
    select(-c('std','raw')) %>%
    inner_join(d_cal, by='replicate')

d_trc %>% 
    ggplot(aes(fragmention, totalarea)) + 
    geom_bar(aes(fill = isotopelabeltype), stat = 'identity') + 
    facet_wrap(~replicate, scales="free_y") + 
    scale_fill_brewer(palette="Set1")

# denisty plot
d_trc %>% 
    ggplot(aes(totalarea)) + 
    geom_density(fill='grey') + 
    facet_wrap(~isotopelabeltype) +
    scale_x_log10()

# histogram plot
d_trc %>% 
    ggplot(aes(totalarea)) + 
    geom_histogram(binwidth = 0.2, fill='grey') + 
    facet_wrap(~isotopelabeltype) +
    scale_x_log10()

# boxplot
d_trc %>% 
    ggplot(aes(fragmention, totalarea, fill=isotopelabeltype)) + 
    geom_boxplot() + 
    scale_y_log10() +
    theme(axis.text.x = element_text(angle = 30, hjust = 1)) + 
    scale_fill_brewer(palette="Set1")

# line plots
d_trc %>% 
    ggplot(aes(replicate, totalarea, color=fragmention)) + 
    geom_point() + 
    geom_line(aes(group=fragmention)) +
    facet_wrap(~isotopelabeltype) +
    scale_y_log10() +
    scale_color_brewer(palette="Set1")


d_trc %>% 
    ggplot(aes(replicate, totalarea, color=isotopelabeltype)) + 
    geom_point() + 
    geom_line(aes(group=isotopelabeltype)) +
    facet_grid(.~fragmention) +
    scale_y_log10() +
    scale_color_brewer(palette="Set1")
