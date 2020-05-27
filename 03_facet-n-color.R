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
d_trc <- "./data/rds/samples_1-8_heavy-light_traces.rds" %>% 
    read_rds() 


d_trc %>% 
    # color by isotope-label
    ggplot(aes(Replicate, TotalArea, color=IsotopeLabelType)) + 
    geom_point() + 
    geom_line()

# Challenge
## 1 - use facet_grid to make a matrix of transitions by isotope-label
## 2 - add a 'grey' smoothed line behind each trace without the confidence interval
## 3 - use a custom color scheme












# Final plot
p_trc <- 
    d_trc %>% 
    # color by isotope-label
    ggplot(aes(Replicate, TotalArea, color=IsotopeLabelType)) + 
    geom_point() + 
    geom_line() +
    
    # facet by transition
    facet_wrap(~FragmentIon, nrow=1) +
    
    # scale by log10
    scale_y_log10() +
    
    # use bolder colors
    scale_color_brewer(palette="Set1") +
    
    # ggplot like to be efficent, lets add back all rep labels
    scale_x_continuous(breaks=1:8) +
    ggtitle("IEAIPQIDK GST-tag", "Response Curves per Transition")


# save plot
pdf(file = "./plots/03_response-curves.pdf", pointsize = 8, width = 10, height = 4)
plot(p_trc)
dev.off()
