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
  # Greens
  `Dark Green` = "#16343E",
  `Emerald` = "#018362",
  `Bright Mint` = "#A3E1B5",
  `Light Green` = "#74A88D",
  `Starting Green` = "#F0F9E8",
  `Middle Green` = "#7DBAA3",
  `Ending Green` = "#16343E",
  # Yellow
  `Bright Gold` = "#FFE474",
  # Oranges
  `RIN Orange` = "#E64F2B",
  `Dark Orange` = "#890005",
  `Mid Orange` = "#F08250",
  `Light Orange` = "#FFF6D2",
  # Blues
  `RISI Blue` = "#234FBF",
  `Dark Blue` = "#280050",
  `Mid Blue` = "#3F8EE6",
  `Light Blue` = "#E5F9F3",
  # Purples
  `RII Purple` = "#48326A",
  `RAP Purple` = "#753984",
  `Dark Purple` = "#211448",
  `Mid Purple` = "#BA578C",
  `Light Purple` = "#FCF2EE",
  # Teals
  `CIF Teal` = "#259299",
  `CIF Mid Teal` = "#06BCCB",
  `Dark Teal` = "#061E46",
  `Mid Teal` = "#65ACA5",
  `Light Teal` = "#F2FBEC",
  # Accents
  `CORI Cream` = "#FBF8E9",
  `CORI Gray` = "#D0D2CE",
  `Nearly Black` = "#121E22"
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
  "ctg2gnalt" = cori_cols("Light Green", "Bright Mint"),
  "ctg2or" = cori_cols("Dark Orange", "Light Orange"),
  "ctg2pu" = cori_cols("Dark Purple", "Light Purple"),
  "ctg2pualt" = cori_cols("Dark Purple", "Mid Purple"),
  "ctg2bu" = cori_cols("Dark Blue", "Light Blue"),
  "ctg3gn" = cori_cols("Starting Green", "Middle Green", "Ending Green"),
  "ctg7" = cori_cols(
    "Dark Green",
    "Emerald",
    "Bright Gold",
    "RIN Orange",
    "RISI Blue",
    "CIF Mid Teal",
    "RII Purple"
  ),
  "ctg4mid" = cori_cols(
    "Mid Blue", "Mid Orange", "Mid Purple", "Mid Teal"
  ),
  "ctg2tlpu" = cori_cols("Mid Teal", "Mid Purple"),
  "ctg2buor" = cori_cols("Mid Blue", "Mid Orange"),
  "ctg5viridis_cori" = cori_cols("Dark Purple", "Mid Blue", "CIF Teal", "Emerald", "Bright Gold")
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
