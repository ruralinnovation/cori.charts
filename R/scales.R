#' Color scales for CORI data visualization
#'
#' @param palette Character name of palette in [cori_palettes()]
#' @param discrete Boolean indicating whether color aesthetic is discrete or not.
#' Defaults to `TRUE`
#' @param reverse Boolean indicating whether the palette should be reversed.
#' Defaults to `FALSE`
#' @param ... Additional arguments passed to [ggplot2::discrete_scale()] or
#' [ggplot2::scale_fill_gradientn()], used respectively when `discrete` is
#' `TRUE` or `FALSE`
#'
#' @examples
#' library(ggplot2)
#' library(dplyr)
#' data(cori_employment)
#' cori_employment %>%
#'   ggplot(
#'     aes(estimate_pop_2014, estimate_pop_2019,
#'         color = estimate_employed_2019
#'     )
#'   ) +
#'   geom_point(size = 4, alpha = .6) +
#'   scale_color_cori(discrete = FALSE, palette = "ctg2pu")
#'
#' library(tidyr)
#' library(stringr)
#' cori_employment %>%
#'   pivot_longer(contains("employed")) %>%
#'   mutate(name = str_remove(name, "estimate_employed_")) %>%
#'   ggplot(aes(value, rin_community, fill = name)) +
#'   geom_col(position = "dodge") +
#'   scale_fill_cori() +
#'   labs(x = "Estimated population employed", y = NULL, fill = NULL)
#' @rdname scales
#' @export
#'
scale_fill_cori <- function(palette = "ctg2gn", discrete = TRUE,
                            reverse = FALSE, ...) {
  pal <- cori_pal(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale(
      "fill", paste0("cori_", palette),
      palette = pal, ...
    )
  } else {
    ggplot2::scale_fill_gradientn(colours = pal(256), ...)
  }
}

#' @rdname scales
#' @export
#'
scale_color_cori <- function(palette = "ctg2gn", discrete = TRUE,
                             reverse = FALSE, ...) {
  pal <- cori_pal(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale(
      "colour", paste0("cori_", palette),
      palette = pal, ...
    )
  } else {
    ggplot2::scale_color_gradientn(colours = pal(256), ...)
  }
}
