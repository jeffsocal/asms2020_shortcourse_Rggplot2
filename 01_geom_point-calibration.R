# ASMS Short Course R::ggplots
# Jeff Jones
# 2020-04-21

library(tidyverse)
library(ggplot2)

# clean out existing variable objects
rm(list=ls())

# set the theme to black-white (remove grey plot area)
# https://ggplot2.tidyverse.org/reference/ggtheme.html
theme_set(theme_bw())

# read in data
d_cal <- "./data/rds/samples_1-8_heavy-light_calibration.rds" %>% 
    read_rds()

# plot x axis is a character 
d_cal %>% 
    ggplot(aes(Replicate, Quant_Value)) + 
    geom_point()









# remove the measurement and color
d_cal %>%
    filter(Replicate != "FOXN1-GST") %>% 
    ggplot(aes(Replicate, Quant_Value)) + 
    geom_line(color="blue") +
    geom_point(color='red', size=3, alpha=.75) +
    ggtitle("calibration data", 
            "points and lines")


# Challenge:
## 1 - move aes into geom_point
## 2 - add geom_line
## 3 - color line blue, points red
## 4 - layer points on top of line
## 5 - set the point alpha 
## 6 - add a title with ggtitle
## 7 - save the plot as a pdf, png (not save.image)
### .1 - by the IDE
### .2 - by code
### .3 - create a save function










# challenge example
p_cal <- d_cal %>%
    filter(Replicate != "FOXN1-GST") %>%
    mutate(Replicate = as.numeric(Replicate)) %>%
    ggplot(aes(Replicate, Quant_Value)) + 
    geom_line(color='blue') +
    geom_point(alpha=.8, color='red', size=2) +
    ggtitle("samples 1-8 heavy/light calibration data")

# save plot
pdf(file = "./plots/01_points-lines.pdf", pointsize = 8, width = 5, height = 4)
plot(p_cal)
dev.off()
