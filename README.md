
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cori.charts <a href='https://ruralinnovation.github.io/cori.charts/'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/ruralinnovation/cori.charts/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ruralinnovation/cori.charts/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of cori.charts is to make the process of creating
publication-ready graphics and charts at the [Center for Rural
Innovation](https://ruralinnovation.us/) as easy as possible. Check out
[the
guidelines](https://www.figma.com/file/gaAFFK9UHvs4baFXDlOKKR/CORI-Design-Guideline),
and then get started.

## Installation

You can install the development version of cori.charts from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ruralinnovation/cori.charts")
```

## Example

This is a basic example which shows the application of the CORI theme:

``` r
library(ggplot2)
library(cori.charts)
theme_set(theme_cori())
update_cori_geom_defaults()

data("cori_education")

ggplot(cori_education, 
       aes(date, percent_working_remotely, color = education)) +
  geom_line() +
  geom_point() +
  scale_color_cori(guide = guide_legend(reverse = TRUE)) +
  scale_x_date(date_breaks = "1 month", date_labels =  "%b") +
  scale_y_continuous(labels = scales::percent, limits = c(NA, 0.8)) +
  labs(title = "Working remotely during 2021",
       subtitle = "By education level",
       x = NULL,
       y = "Percentage %")
```

<img src="man/figures/README-example-1.png" width="100%" />

Check out the vignette for a [cookbook of CORI-themed
plots](https://ruralinnovation.github.io/cori.charts/articles/cookbook.html)!

## Contributing

Please note that the cori.charts project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
