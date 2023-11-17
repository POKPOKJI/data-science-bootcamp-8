# load ggplot library

library(ggplot2)

ggplot(diamonds, aes(carat,price)) +
  geom_point() +
  geom_smooth()
