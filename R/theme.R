#' A [ggplot2] theme for the Center on Rural Innovation (CORI) style
#'
#' `theme_cori()` provides a [ggplot2] theme formatted according to the CORI
#' style guide.
#'
#' @param base_family Font family that CORI employs, defaults to  "TT Hoves"
#' @param base_size Base text font size, defaults to 12
#'
#' @rdname theme_cori
#' @export
#'
theme_cori <- function(base_family = "TT Hoves", base_size = 12) {
  gray <- "#666666"

  ret <- ggplot2::theme_minimal(
    base_family = base_family,
    base_size = base_size
  )

  # Panel Attributes
  ret$panel.grid.major.x <- ggplot2::element_blank()
  ret$panel.grid.minor.x <- ggplot2::element_blank()
  ret$panel.grid.minor.y <- ggplot2::element_blank()
  ret$panel.grid.major.y <- ggplot2::element_line(
    linetype = "dashed",
    color = gray
  )
  ret$panel.background = ggplot2::element_blank()


  # Axis Attributes
  ret$axis.title.x <- ggplot2::element_text(hjust = 0, size = 10.5)
  ret$axis.title.y <- ggplot2::element_text(
    hjust = 1, angle = 90,
    margin = ggplot2::margin(r = 10)
  )
  ret$axis.line.x <- ggplot2::element_line(color = "grey", linetype = "solid")
  ret$axis.text.x <- ggplot2::element_text(hjust = 0.5, size = 10.5, color = "#121E22")
  ret$axis.text.y <- ggplot2::element_text(hjust = 1, size = 10.5, color = "#121E22")

  # Plot Attributes
  ret$plot.title <- ggplot2::element_text(
    size = 18,
    hjust = 0,
    face = "bold",
    margin = ggplot2::margin(b = 10),
    color = "#121E22"
  )

  ret$plot.subtitle <- ggplot2::element_text(
    size = 12,
    hjust = 0,
    margin = ggplot2::margin(b = 12),
    color = "#121E22"
  )

  ret$plot.caption <- ggplot2::element_text(
    color = gray, size = 8, hjust = 0,
    margin = ggplot2::margin(t = -35, b = 40)
  )

  ret$plot.margin = ggplot2::margin(t = base_size/2L,
                                  r = base_size/2L,
                                  b = base_size/2L,
                                  l = base_size/2L)

  # Legend attributes
  ret$legend.title <- ggplot2::element_blank()
  ret$legend.position <- "bottom"
  ret$legend.justification <- c(0, 0)

  ret
}

#' @rdname theme_cori
#' @export
#'
theme_cori_horizontal_bars <- function(base_family = "TT Hoves", base_size = 12) {
  ret <- theme_cori(
    base_family = base_family,
    base_size = base_size
  )

  ret$panel.grid.major.y <- ggplot2::element_blank()

  ret
}