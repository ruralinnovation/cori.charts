#' Watermark
#'
#' Add the CORI watermark as a background to a [ggplot2] object
#'
#' @examples
#' library(ggplot2)
#' library(dplyr)
#' data(cori_employment)
#' cori_employment %>%
#'   ggplot(aes(estimate_pop_2014, estimate_pop_2019)) +
#'   geom_watermark(alpha = 0.1) +
#'   geom_point(size = 4, alpha = .6)
#' @param alpha Opacity for the watermark, defaults to 0.2
#' @export
geom_watermark <- function(alpha = 0.2) {
  m <- png::readPNG(system.file("img", "logo.png", package = "cori.charts"))
  img <- matrix(
    grDevices::rgb(m[, , 1], m[, , 2], m[, , 3], m[, , 4] * alpha),
    nrow = dim(m)[1]
  )
  ggplot2::annotation_custom(
    grid::rasterGrob(img),
    xmin = -Inf,
    xmax = Inf,
    ymin = -Inf,
    ymax = Inf
  )
}
