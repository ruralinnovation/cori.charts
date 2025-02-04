#' A [ggplot2] theme for the Center on Rural Innovation (CORI) style
#'
#' `theme_cori()` provides a [ggplot2] theme formatted according to the CORI
#' style guide.
#'
#' @param title_family Font family that CORI employs for titles, defaults to  "Lato"
#' @param base_family Font family that CORI employs, defaults to  "Lato"
#' @param base_size Base text font size, defaults to 12
#'
#' @rdname theme_cori
#' @export
#'
theme_cori <- function(title_family = "Lato", base_family = "Lato", base_size = 15) {

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
    linetype = "solid",
    color = gray,
    linewidth = .25
  )
  ret$panel.background = ggplot2::element_blank()

  # Axis Attributes
  ret$axis.title <- ggplot2::element_text(face = "italic")
  ret$axis.title.x <- ggplot2::element_text(
    margin = ggplot2::margin(t = 10),
    hjust = 0.5,
    size = base_size
  )
  ret$axis.title.y <- ggplot2::element_text(
    hjust = 0.5,
    angle = 90,
    margin = ggplot2::margin(r = 10)
  )
  ret$axis.line.x <- ggplot2::element_blank()
  ret$axis.ticks.length.x = ggplot2::unit(10, "pt")
  ret$axis.text.x <- ggplot2::element_text(
    hjust = 0.5,
    size = base_size,
    color = black,
    margin = ggplot2::margin(t = 4)
  )
  ret$axis.text.y <- ggplot2::element_text(
    hjust = 1,
    size = base_size,
    color = black,
    margin = margin(r = 4)
  )

  ret$axis.ticks.length.y.right = ggplot2::unit(0, "pt")

  # Plot Attributes
  ret$plot.title <- ggplot2::element_text(
    size = 20,
    hjust = 0,
    face = "plain",
    margin = ggplot2::margin(b = 10),
    color = black,
    family = title_family
  )
  ret$plot.title.position <- "plot"

  ret$plot.subtitle <- ggplot2::element_text(
    size = 16,
    hjust = 0,
    face = "italic",
    margin = ggplot2::margin(b = 12),
    color = black,
    family = title_family
  )

  ret$plot.caption <- ggplot2::element_text(
    color = black,
    size = 13,
    hjust = 0,
    margin = ggplot2::margin(t = 15, b = 0)
  )
  ret$plot.caption.position <-  "plot"

  ret$plot.margin <- ggplot2::margin(base_size, base_size, base_size, base_size, "pt")

  # Legend attributes
  ret$legend.background <- ggplot2::element_blank()
  ret$legend.spacing <- ggplot2::unit(20L, "pt")
  ret$legend.spacing.x <- ggplot2::unit(5L, "pt")
  ret$legend.spacing.y <- ggplot2::unit(10L, "pt")
  ret$legend.key <- ggplot2::element_blank()
  ret$legend.key.size <- ggplot2::unit(base_size, "pt")
  ret$legend.text <- ggplot2::element_text(size = base_size, vjust = 0.5, color = "#121E22")
  ret$legend.title <- ggplot2::element_blank()
  ret$legend.position <- "top"
  ret$legend.direction <- "horizontal"
  ret$legend.margin <- ggplot2::margin(t = 0L, r = 0L, b = 0L, l = 0L, "pt")
  ret$legend.box <- "horizontal"
  ret$legend.justification <- NULL

  ret
}

#' A [ggplot2] theme for the Center on Rural Innovation (CORI) style
#'
#' `theme_cori_horizontal_bars()` provides a [ggplot2] theme formatted according to the CORI
#' style guide for horizontal bar charts
#'
#' @param title_family Font family that CORI employs for titles, defaults to  "Lato"
#' @param base_family Font family that CORI employs, defaults to  "Lato"
#' @param base_size Base text font size, defaults to 12
#'
#' @rdname theme_cori_horizontal_bars
#' @export
#'
theme_cori_horizontal_bars <- function(title_family = "Lato", base_family = "Lato", base_size = 15) {
  ret <- theme_cori(
    title_family = title_family,
    base_family = base_family,
    base_size = base_size
  )

  # show only vertical lines
  ret$panel.grid.major.y <- ggplot2::element_blank()
  ret$panel.grid.major.x = ggplot2::element_line(colour = "#d0d2ce", size = .3)
  ret$axis.line.x.bottom = ggplot2::element_blank()
  ret$panel.grid.major.x = ggplot2::element_blank()
  ret$axis.line.y = ggplot2::element_blank()

  ret
}

#' A [ggplot2] theme for the Center on Rural Innovation (CORI) style
#'
#' `theme_cori_map()` provides a [ggplot2] theme formatted according to the CORI
#' style guide for maps (choropleth or dot density)
#'
#' @param title_family Font family that CORI employs for titles, defaults to  "Lato"
#' @param base_family Font family that CORI employs, defaults to  "Lato"
#' @param base_size Base text font size, defaults to 12
#'
#' @rdname theme_cori_map
#' @export
#'
theme_cori_map <- function(title_family = "Lato", base_family = "Lato", base_size = 15) {

  ret <- theme_cori(
    title_family = title_family,
    base_family = base_family,
    base_size = base_size
  )

  # Hide x and y text
  ret$axis.text.x = ggplot2::element_blank()
  ret$axis.text.y = ggplot2::element_blank()

  # Hide ticks
  ret$axis.ticks = ggplot2::element_blank()

  # Remove background rectangle
  ret$rect = ggplot2::element_blank()
  ret$panel.grid.major = ggplot2::element_blank()

  # Remove bottom line
  ret$axis.line.x.bottom = ggplot2::element_blank()

  ret
}

#' A [ggplot2] theme for the Center on Rural Innovation (CORI) style
#'
#' `theme_cori_presentation()` provides a [ggplot2] theme formatted for presentations
#'
#' @param title_family Font family that CORI employs for titles, defaults to  "Lato"
#' @param base_family Font family that CORI employs, defaults to  "Lato"
#' @param base_size Base text font size, defaults to 12
#'
#' @rdname theme_cori_presentation
#' @export
#'
theme_cori_presentation <- function(title_family = "Lato", base_family = "Lato", base_size = 12) {

  gray <- "#d0d2ce"
  dark_gray <- "#8e8e8e"
  black <- "#121E22"

  ret <- theme_cori(
    title_family = title_family,
    base_family = base_family,
    base_size = base_size
  )

  # Increase font sizes for easier viewing in slide deck
  ret$plot.title <- ggplot2::element_text(
    size = 32,
    hjust = 0,
    face = "plain",
    margin = ggplot2::margin(b = 10),
    color = black,
    family = title_family
  )

  ret$plot.subtitle <- ggplot2::element_text(
    size = 20,
    hjust = 0,
    face = "italic",
    margin = ggplot2::margin(b = 12),
    color = black,
    family = title_family
  )

  ret$plot.caption <- ggplot2::element_text(
    color = black,
    size = 16,
    hjust = 0,
    margin = ggplot2::margin(t = 15, b = 0)
  )

  ret$axis.title.x <- ggplot2::element_text(
    margin = ggplot2::margin(t = 10),
    hjust = 0.5,
    size = 16
  )
  ret$axis.title.y <- ggplot2::element_text(
    hjust = 0.5,
    angle = 90,
    margin = ggplot2::margin(r = 10),
    size = 16
  )

  ret$axis.text.x <- ggplot2::element_text(
    hjust = 0.5,
    size = 16,
    color = black,
    margin = ggplot2::margin(r = 4)
  )
  ret$axis.text.y <- ggplot2::element_text(
    hjust = 1,
    size = 16,
    color = black
  )

  ret$legend.key.size <- ggplot2::unit(16, "pt")
  ret$legend.text <- ggplot2::element_text(size = 16, vjust = 0.5, color = "#121E22")

  ret

}

#' A [ggplot2] theme for the Center on Rural Innovation (CORI) style
#'
#' `theme_cori_map_presentation()` provides a [ggplot2] theme formatted for maps
#' used in presentations
#'
#' @param title_family Font family that CORI employs for titles, defaults to  "Lato"
#' @param base_family Font family that CORI employs, defaults to  "Lato"
#' @param base_size Base text font size, defaults to 12
#'
#' @rdname theme_cori_map_presentation
#' @export
#'
theme_cori_map_presentation <- function(title_family = "Lato", base_family = "Lato", base_size = 12) {

  gray <- "#d0d2ce"
  dark_gray <- "#8e8e8e"
  black <- "#121E22"

  ret <- theme_cori_map(
    title_family = title_family,
    base_family = base_family,
    base_size = base_size
  )

  # Increase font sizes for easier viewing in slide deck
  ret$plot.title <- ggplot2::element_text(
    size = 32,
    hjust = 0,
    face = "plain",
    margin = ggplot2::margin(b = 10),
    color = black,
    family = title_family
  )

  ret$plot.subtitle <- ggplot2::element_text(
    size = 20,
    hjust = 0,
    face = "italic",
    margin = ggplot2::margin(b = 12),
    color = black,
    family = title_family
  )

  ret$plot.caption <- ggplot2::element_text(
    color = black,
    size = 16,
    hjust = 0,
    margin = ggplot2::margin(t = 15, b = 0)
  )

  ret$axis.title.x <- ggplot2::element_text(
    margin = ggplot2::margin(t = 10),
    hjust = 0.5,
    size = 16
  )
  ret$axis.title.y <- ggplot2::element_text(
    hjust = 0.5,
    angle = 90,
    margin = ggplot2::margin(r = 10),
    size = 16
  )

  ret$legend.key.size <- ggplot2::unit(16, "pt")
  ret$legend.text <- ggplot2::element_text(size = 16, vjust = 0.5, color = "#121E22")

  ret

}
