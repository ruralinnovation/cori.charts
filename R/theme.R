#' A [ggplot2] theme for the Center on Rural Innovation (CORI) style
#'
#' `theme_cori()` provides a [ggplot2] theme formatted according to the CORI
#' style guide.
#'
#' @param base_family Font family that CORI employs, defaults to  "TT Hoves"
#' @param base_font_size Base text font size, defaults to 12
#'
#' @export
#'
theme_cori <- function(base_family = "TT Hoves", base_font_size = 12) {
  black <- "#121E22"
  gray <- "#666666"

  ret <- ggplot2::theme_minimal(
    base_family = base_family,
    base_size = base_font_size
  )

  # Panel Attributes
  ret$panel.grid.major.x <- ggplot2::element_blank()
  ret$panel.grid.minor.x <- ggplot2::element_blank()
  ret$panel.grid.minor.y <- ggplot2::element_blank()
  ret$panel.grid.major.y <- ggplot2::element_line(
    linetype = "dashed",
    color = "grey"
  )

  # Axis Attributes
  ret$axis.title.x <- ggplot2::element_text(
    hjust = 0, size = 10.5,
    margin = ggplot2::margin(t = 19.5, b = 4, unit = "pt")
  )
  ret$axis.title.y <- ggplot2::element_text(
    hjust = 1, angle = 90,
    margin = ggplot2::margin(t = 50, unit = "pt")
  )
  ret$axis.line.x <- ggplot2::element_line(color = "grey", linetype = "solid")
  ret$axis.text.x <- ggplot2::element_text(size = 10.5, hjust = 0.5)
  ret$axis.text.y <- ggplot2::element_text(
    size = 10.5, hjust = 1,
    margin = ggplot2::margin(l = 4, r = 6, unit = "pt")
  )

  # Plot Attributes
  ret$plot.title <- ggplot2::element_text(
    size = 18,
    hjust = 0,
    face = "bold",
    color = "#121E22",
    lineheight = 1.2,
    margin = ggplot2::margin(t = 18, b = 11.25, unit = "pt")
  )

  ret$plot.subtitle <- ggplot2::element_text(
    size = 12,
    hjust = 0L,
    lineheight = 1.5,
    margin = ggplot2::margin(b = 32.5, unit = "pt")
  )

  ret$plot.caption <- ggplot2::element_text(
    color = gray, size = 8, hjust = 0.015,
    margin = ggplot2::margin(t = -35, b = 40)
  )

  # Legend attributes
  ret$legend.title <- ggplot2::element_blank()
  ret$legend.position = "bottom"
  ret$legend.justification = c(0,0)

  ret

}
