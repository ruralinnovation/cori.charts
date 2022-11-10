#' The Center for Rural Innovation [ggplot2] theme
#'
#' `update_cori_geom_defaults()` provides a [ggplot2] theme that aligns with the
#' CORI style guide, with sensible defaults.
#'
#' @param base_family The base font family for the theme, defaults to "Lato".
#'
#' @examples
#' library(ggplot2)
#' library(dplyr)
#' data(cori_employment)
#'
#' update_cori_geom_defaults()
#' cori_education %>%
#'   group_by(date) %>%
#'   summarize(percent_working_remotely = mean(percent_working_remotely)) %>%
#'   ggplot(aes(date, percent_working_remotely)) +
#'   geom_hline(yintercept = 0.12) +
#'   scale_y_continuous(labels = scales::percent) +
#'   geom_line() +
#'   geom_point()
#' @export
#'
update_cori_geom_defaults <- function(base_family = "Lato") {

  # add base_family font to text and label geoms ---------------------------

  ggplot2::update_geom_defaults("text", list(family = base_family, color = "#121E22"))
  ggplot2::update_geom_defaults("label", list(family = base_family, color = "#121E22"))

  # set defaults for geoms --------------------------------------------------

  ggplot2::update_geom_defaults("point", list(colour = "#00835D", size = 3))
  ggplot2::update_geom_defaults("line", list(colour = "#00835D", size = 1.5, alpha = 0.8))
  ggplot2::update_geom_defaults("rect", list(fill = "#00835D", alpha = 0.9))
  ggplot2::update_geom_defaults("vline", list(colour = "#D2D6D7", size = 1.2, lty = 2))
  ggplot2::update_geom_defaults("hline", list(colour = "#D2D6D7", size = 1.2, lty = 2))
}
