# codereportr


<!-- README.md is generated from README.qmd. Please edit that file -->

# codereportr

<!-- badges: start -->

<!-- badges: end -->

The goal of codereportr is to make it easier to check reproduction
packages for data/code reviews

## Installation

You can install the development version of codereportr like so:

``` r
pak::pak("JBGruber/codereportr")
```

## Example

This is a basic example which shows how to turn a single R script into a
code report using the default [Quarto
template](https://github.com/JBGruber/codereportr/blob/main/inst/template.qmd).
It uses a small [example
script](https://github.com/JBGruber/codereportr/blob/main/inst/example_script.R)
that comes with the packagage.

``` r
library(codereportr)
create_report(
  input_files = system.file("example_script.R", package = "codereportr"),
  output_file = "code_report.qmd"
)
#> ✔ Successfully converted /home/johannes/R/x86_64-pc-linux-gnu-library/4.5/codereportr/example_script.R to code_report.qmd
```

The output will look like this:

     ---
     title: Code Report
     date: today
     format:
       html:
         toc: true
         toc_depth: 3
         toc_float: true
         number_sections: true
     execute: 
       echo: true
       warning: true
       error: true
     ---
     
     # Introduction
     
     This is a code report of:
     
     - /home/johannes/R/x86_64-pc-linux-gnu-library/4.5/codereportr/example_script.R
     
     ```{r}
     start <- Sys.time() # note start time for later
     ```
     
     # Code
     
     ```{r}
     # example R script for tests and examples, with comments, warnings and errors
     # library(ggplot2)
     library(dplyr)
     ```
     
     ```{r}
     # Load data
     data <- mtcars
     ```
     
     ```{r}
     # Create a summary
     summary_stats <- data %>%
       group_by(cyl) %>%
       summarise(
         mean_mpg = mean(mpg),
         mean_hp = mean(hp)
       )
     ```
     
     ```{r}
     # Print summary
     print(summary_stats)
     ```
     
     ```{r}
     # Create a plot
     ggplot(data, aes(x = wt, y = mpg)) +
       geom_point() +
       geom_smooth(method = "lm") +
       theme_minimal()
     ```
     
     ```{r}
     # warning
     warning("test")
     ```
     
     ```{r}
     # error
     mean[1]
     ```
     
     
     # wrap up
     
     Some session information.
     
     ```{r}
     sessionInfo()
     Sys.time()
     # note how long the script takes to (re-)run
     Sys.time() - start
     ```

Note that each runnable chunk is put separately into the quarto file, so
it becomes easier to find where an output, warning, or error originates
in the rendered version.

To render the code, you need [Quarto](https://quarto.org):

``` bash
quarto render code_report.qmd
```
