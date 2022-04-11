#' A [ggplot2] theme for the Center on Rural Innovation (CORI) style
#'
#' `theme_cori()` provides a [ggplot2] theme formatted according to the CORI
#' style guide.
#'
#' @param base_family Font family that CORI employs, defaults to  "Montserrat"
#' @param base_size Base text font size, defaults to 12
#'
#' @rdname theme_cori
#' @export
#'
theme_cori <- function(base_family = "Montserrat", base_size = 12) {
  
  gray <- "#d0d2ce"
  dark_gray <- "#8e8e8e"
  black <- "#121E22"

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
  ret$axis.title <- ggplot2::element_text(face = "italic")
  ret$axis.title.x <- ggplot2::element_text(
    margin = ggplot2::margin(t = 10),
    hjust = 0.5,
    size = 10.5
  )
  ret$axis.title.y <- ggplot2::element_text(
    hjust = 1,
    angle = 90,
    margin = ggplot2::margin(r = 10)
  )
  ret$axis.line.x <- ggplot2::element_line(color = gray, linetype = "solid")
  ret$axis.text.x <- ggplot2::element_text(hjust = 0.5, size = 10.5, color = black)
  ret$axis.text.y <- ggplot2::element_text(hjust = 1, size = 10.5, color = black)

  # Plot Attributes
  ret$plot.title <- ggplot2::element_text(
    size = 18,
    hjust = 0,
    face = "bold",
    margin = ggplot2::margin(b = 10),
    color = black
  )

  ret$plot.subtitle <- ggplot2::element_text(
    size = 12,
    hjust = 0,
    margin = ggplot2::margin(b = 12),
    color = black
  )

  ret$plot.caption <- ggplot2::element_text(
    color = dark_gray,
    size = 10.5,
    hjust = 0,
    margin = ggplot2::margin(t = 25, b = 0)
  )

  # Legend attributes
  ret$legend.background <- ggplot2::element_blank()
  ret$legend.spacing <- ggplot2::unit(20L, "pt")
  ret$legend.spacing.x <- ggplot2::unit(4L, "pt")
  ret$legend.key <- ggplot2::element_blank()
  ret$legend.key.size <- ggplot2::unit(10L, "pt")
  ret$legend.text <- ggplot2::element_text(size = 10.5, vjust = 0.5, color = "#121E22")
  ret$legend.title <- ggplot2::element_blank()
  ret$legend.position <- "top"
  ret$legend.direction <- "horizontal"
  ret$legend.margin <- ggplot2::margin(t = 0L, r = 0L, b = 0L, l = 0L, "pt")
  ret$legend.box <- "horizontal"
  ret$legend.justification <- NULL

  ret
}

#' @rdname theme_cori
#' @export
#'
theme_cori_horizontal_bars <- function(base_family = "Montserrat", base_size = 12) {
  ret <- theme_cori(
    base_family = base_family,
    base_size = base_size
  )

  # show only vertical lines
  ret$panel.grid.major.y <- ggplot2::element_blank()
  ret$panel.grid.major.x = element_line(colour = "#d0d2ce", size = .3)
  ret$axis.line.x.bottom = element_blank()

  ret
}
