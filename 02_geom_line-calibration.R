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
    read_rds() %>%
    filter(Replicate != "FOXN1-GST")

# plot the Quant_Value ~ ratio_to_std
d_cal %>%
    ggplot(aes(Ratio_To_Standard, Quant_Value)) + 
    geom_point() +
    geom_line() 

# add a linear smothed line
# geom_smooth(method="lm", fill=NA)     

# generate a linear model
model_lm <- lm(d_cal$Quant_Value ~ d_cal$Ratio_To_Standard)

# examine the model
model_lm_summary <- model_lm %>% summary()

# plot the data with the linear regression model
p_cal <- d_cal %>%
    ggplot(aes(Ratio_To_Standard, Quant_Value)) + 
    geom_point(size=3) +
    
    # draw the linear regression
    # geom_smooth(method="lm", fill=NA, color="black", size=1) +
    geom_abline(slope = model_lm_summary$coefficients[2],
                intercept = model_lm_summary$coefficients[1],
                color='red') +
    
    # add a title
    ggtitle("IEAIPQIDK GST-tag", "Calibration Curve") +
    
    # add regression stats
    annotate("label", x=-Inf, y=Inf,
             hjust=0, vjust=1,
             label = paste0(
                 "r.squared: ", signif(model_lm_summary$r.squared, 3), "\n",
                 "adj.r.squared: ", signif(model_lm_summary$adj.r.squared, 3)) )

# save plot
pdf(file = "./plots/02_calibration.pdf", pointsize = 8, width = 5, height = 4)
plot(p_cal)
dev.off()