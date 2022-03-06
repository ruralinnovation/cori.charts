#' Functions for handling CORI colors
#'
#' These utility functions provide fluent access to CORI colors and palettes in
#' formats ready for [ggplot2].
#'
#' @examples
#' cori_colors["Emerald"]
#' cori_cols("Emerald")
#' cori_palettes[["ctg2gn"]]
#' cori_pal("ctg7")
#' @rdname colors
#' @export
#'
cori_colors <- c(
  `Emerald` = "#018362", `Bright Mint` = "#A3E1B5",
  `Bright Gold` = "#FFE474",
  `RIN Orange` = "#E64F2B", `Mid Orange` = "#FA804B", `Light Orange` = "#FECEB8",
  `RIN Blue` = "#234FBF", `Mid Blue` = "#3E80EA", `Light Blue` = "#B4CEF9",
  `RII Purple` = "#48326A", `Mid Purple` = "#7658A2", `Light Purple` = "#CBBEDC",
  `CIF Mid Blue` = "#02BCCB"
)

#' @rdname colors
#' @export
#'
cori_cols <- function(...) {
  cols <- c(...)

  if (is.null(cols)) {
    return(cori_colors)
  }

  cori_colors[cols]
}

#' @rdname colors
#' @export
#'
cori_palettes <- list(
  "ctg2gn" = cori_cols("Emerald", "Bright Mint"),
  "ctg2or" = cori_cols("RIN Orange", "Light Orange"),
  "ctg2pu" = cori_cols("RII Purple", "Light Purple"),
  "ctg2bu" = cori_cols("RIN Blue", "Light Blue"),
  "ctg7" = cori_cols(
    "Emerald", "Bright Mint",
    "Bright Gold",
    "Mid Orange", "Mid Blue",
    "Mid Purple", "CIF Mid Blue"
  )
)

#' @param palette Character name of palette in [cori_palettes]
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments to pass to [grDevices::colorRampPalette]
#'
#' @rdname colors
#' @export
#'
cori_pal <- function(palette = "ctg2gn", reverse = FALSE, ...) {
  pal <- cori_palettes[[palette]]

  if (reverse) pal <- rev(pal)

  grDevices::colorRampPalette(pal, ...)
}
