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

# plot the quant_value ~ ratio_to_std
d_cal %>%
    filter(replicate != "FOXN1-GST") %>%
    ggplot(aes(ratio_to_standard, quant_value)) + 
    geom_point() +
    geom_line() 

# add a linear smothed line
# geom_smooth(method="lm", fill=NA)


# generate a linear model
model_lm <- lm(d_cal$quant_value[1:8] ~ d_cal$ratio_to_standard[1:8])

# examine the model
model_lm_summary <- model_lm %>% summary()

# plot the data with the linear regression model
d_cal %>%
    mutate(measurement = ifelse(replicate != "FOXN1-GST", "calibration", replicate)) %>%
    ggplot(aes(ratio_to_standard, quant_value)) + 
    geom_point(aes(color=measurement), size=3) +
    
    # draw the linear regression
    geom_smooth(method="lm", fill=NA, color="black") +
    
    # log-ify the scales
    scale_y_log10() +
    scale_x_log10() +
    
    # add in a better color palette
    scale_color_brewer(palette="Set1") +
    ggtitle("IEAIPQIDK GST-tag", "Calibration Curve") +
    annotate("label", x=0, y=Inf,
             hjust=0, vjust=1,
             label = paste0(
                 "r.squared: ", signif(model_lm_summary$r.squared, 3), "\n",
                 "adj.r.squared: ", signif(model_lm_summary$adj.r.squared, 3)
             )
    )
