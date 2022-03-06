#' Add a vertical or horizontal line with an annotation
#'
#' This is a utility function that allows the user to add a line threshold with
#' text annotation using an intercept parameter.
#' The shift parameter allows the user to relatively adjust the text with
#' respect to the defined threshold value.
#'
#' @examples
#'
#' library(ggplot2)
#' update_cori_geom_defaults()
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   geom_threshold_annotate(20, axis = "y", shift = 1, label = "20 mpg")
#' @param intercept x or y intercept (indicated by `axis`) through which the
#' vertical or horizontal threshold is made.
#' @param axis Axis along which a threshold is to be added, defaults to "x"
#' indicating a vertical threshold
#' @param label Label to add to the graph, defaults to an empty string
#' @param shift How much to shift the label in `shift` units above the
#' threshold line along "y", or in `shift` units to the right of the
#' threshold line along "x", defaults to 0
#' @param ... Other arguments passed to [ggplot2::annotate()]
#' @export
geom_threshold_annotate <- function(intercept, axis = c("x", "y"),
                                    label = "", shift = 0) {
  rlang::arg_match(axis)
  if (axis == "x") {
    list(
      geom_vline(xintercept = intercept),
      annotate(
        geom = "text", x = intercept + shift, y = Inf,
        label = label, color = "#06BCCB", vjust = "top",
        family = cori_font, ...
      )
    )
  } else {
    list(
      geom_hline(yintercept = intercept),
      annotate(
        geom = "text", y = intercept + shift, x = Inf,
        label = label, color = "#06BCCB", hjust = "right", size = 10.5,
        family = cori_font, ...
      )
    )
  }
}
