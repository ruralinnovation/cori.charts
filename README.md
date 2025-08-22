
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cori.charts <a href='https://ruralinnovation.github.io/cori.charts/'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/ruralinnovation/cori.charts/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ruralinnovation/cori.charts/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of cori.charts is to make the process of creating
publication-ready graphics and charts at the [Center for Rural
Innovation](https://ruralinnovation.us/) as easy as possible.

## Installation

You can install the development version of cori.charts from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ruralinnovation/cori.charts")
```

## Examples

Check out the vignette for a [cookbook of CORI-themed
plots](https://ruralinnovation.github.io/cori.charts/articles/cookbook.html)!

## Code organization

- **`R/theme.R`** contains theme-ing functions (for updating ggplot
  defaults)
- **`R/broadband.R`** contains utility functions for producing broadband
  planning maps.
- **`R/colors.R`** defines CORI color options and palettes.
- **`R/export.R`** contains functions for saving visualizations as PNGs
  and SVGs.
- **`R/fonts.R`** contains utility functions for working with Google
  Fonts.  
- **`R/scales.R`** contains functions for creating fill and color scales
  based upon CORI color palettes.

## Contributing

Please note that the cori.charts project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
