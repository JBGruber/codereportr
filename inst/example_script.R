# example R script for tests and examples, with comments, warnings and errors
# library(ggplot2)
library(dplyr)

# Load data
data <- mtcars

# Create a summary
summary_stats <- data %>%
  group_by(cyl) %>%
  summarise(
    mean_mpg = mean(mpg),
    mean_hp = mean(hp)
  )

# Print summary
print(summary_stats)

# Create a plot
ggplot(data, aes(x = wt, y = mpg)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()

# warning
warning("test")

# error
mean[1]
