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
  ret$panel.background <- ggplot2::element_blank()

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
  axis.ticks.x = ggplot2::element_line(
    color = gray,
    linewidth = .25,
    linetype = "solid"
  )
  ret$axis.ticks.length.x <- ggplot2::unit(10, "pt")
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
    margin = ggplot2::margin(r = 4)
  )

  ret$axis.ticks.length.y.right = ggplot2::unit(0, "pt")

  # Plot Attributes
  ret$plot.title <- ggplot2::element_text(
    size = 20,
    hjust = 0,
    face = "bold",
    lineheight = 1.1,
    margin = ggplot2::margin(b = 16),
    color = black,
    family = title_family
  )
  ret$plot.title.position <- "plot"

  ret$plot.subtitle <- ggplot2::element_text(
    size = 16,
    hjust = 0,
    face = "italic",
    lineheight = 1.1,
    margin = ggplot2::margin(b = 16),
    color = black,
    family = title_family
  )

  ret$plot.caption <- ggplot2::element_text(
    color = black,
    size = 13,
    hjust = 0,
    margin = ggplot2::margin(t = 15, b = 0),
    lineheight = 1.1
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
  ret$panel.grid.major.x <- ggplot2::element_line(
    color = "#d0d2ce",
    linewidth = .25,
    linetype = "solid"
  )
  ret$axis.line.x.bottom <- ggplot2::element_blank()
  ret$axis.text.x <- ggplot2::element_blank()
  ret$panel.grid.major.x <- ggplot2::element_blank()
  ret$axis.line.y <- ggplot2::element_blank()

  ret
}

#' A [ggplot2] theme for the Center on Rural Innovation (CORI) style
#'
#' `theme_cori_line()` provides a [ggplot2] theme formatted according to the CORI
#' style guide for line charts
#'
#' @param title_family Font family that CORI employs for titles, defaults to  "Lato"
#' @param base_family Font family that CORI employs, defaults to  "Lato"
#' @param base_size Base text font size, defaults to 12
#'
#' @rdname theme_cori_line
#' @export
#'
theme_cori_line <- function(title_family = "Lato", base_family = "Lato", base_size = 15) {

  ret <- theme_cori(
    title_family = title_family,
    base_family = base_family,
    base_size = base_size
  )

  # show only vertical lines
  ret$axis.text.y.right <- ggplot2::element_text(margin = ggplot2::margin(l = 4))

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
  ret$axis.text.x <- ggplot2::element_blank()
  ret$axis.text.y <- ggplot2::element_blank()

  # Hide ticks
  ret$axis.ticks <- ggplot2::element_blank()

  # Remove background rectangle
  ret$rect <- ggplot2::element_blank()
  ret$panel.grid.major <- ggplot2::element_blank()

  # Remove bottom line
  ret$axis.line.x.bottom <- ggplot2::element_blank()

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

# =============================================================================
# Chart Specification & Export Utilities
# =============================================================================
# Functions for precise, physically-locked chart output:
#   - cori_chart_spec(): Define chart dimensions and typography
#   - set_chart_limits(): Truncate gridlines at last data point
#   - label_lines(): Direct end-of-line labeling with overlap prevention

#' Chart specification constants for precise, physically-locked output
#'
#' Returns a named list of constants that control all physical dimensions of
#' CORI charts: canvas widths, font sizes (in points), line widths (in mm),
#' tick lengths (in points), and export DPI. All downstream functions
#' (\code{theme_cori_precise}, \code{label_lines}, \code{save_chart}) accept
#' a \code{spec} argument and read from this object.
#'
#' Calling with no arguments returns the package defaults, which are designed
#' for standard US Letter reports (6.5" text width) and 16:9 PowerPoint slides
#' (4.75" chart column). Override only what you need.
#'
#' @param width_report Numeric. Chart width in inches for Word report output.
#'   Default: 6.5 (US Letter with 1" margins, full text width).
#' @param width_slide Numeric. Chart width in inches for PowerPoint slide output.
#'   Default: 4.75 (16:9 slide with text column occupying ~38% of slide width).
#' @param dpi Integer. Export resolution in dots per inch. Default: 300.
#' @param aspect_ratio Numeric. Chart height as a proportion of width
#'   (height = width * aspect_ratio). Default: 0.625.
#' @param font_title Numeric. Plot title size in points. Default: 13.
#' @param font_subtitle Numeric. Plot subtitle size in points. Default: 10.
#' @param font_axis Numeric. Axis tick label size in points. Default: 8.
#' @param font_axis_title Numeric. Axis title size in points. Default: 8.
#' @param font_caption Numeric. Caption text size in points. Default: 7.
#' @param font_label Numeric. Direct data label size in points (used by
#'   \code{label_lines}). Default: 8.
#' @param font_legend Numeric. Legend text size in points. Default: 8.
#' @param tick_length Numeric. X-axis tick length in points. Default: 4.
#' @param gridline_width Numeric. Major gridline stroke width in mm. Default: 0.25.
#' @param axis_line_width Numeric. Axis line stroke width in mm. Default: 0.4.
#'
#' @return A named list of chart specification constants.
#' @export
#'
#' @examples
#' # Use package defaults — no setup required
#' spec <- cori_chart_spec()
#'
#' # Override a single value
#' spec <- cori_chart_spec(font_axis = 7)
#'
#' # Override for a specific report with smaller fonts
#' spec <- cori_chart_spec(font_title = 11, font_subtitle = 9, font_axis = 7)
cori_chart_spec <- function(
    width_report    = 6.5,
    width_slide     = 4.75,
    dpi             = 300,
    aspect_ratio    = 0.625,
    font_title      = 11,
    font_subtitle   = 9,
    font_axis       = 8,
    font_axis_title = 8,
    font_caption    = 8,
    font_label      = 9,
    font_legend     = 9,
    tick_length     = 4,
    gridline_width  = 0.25,
    axis_line_width = 0.4,
    line_width      = 1.5
) {
  list(
    width_report    = width_report,
    width_slide     = width_slide,
    dpi             = dpi,
    aspect_ratio    = aspect_ratio,
    font_title      = font_title,
    font_subtitle   = font_subtitle,
    font_axis       = font_axis,
    font_axis_title = font_axis_title,
    font_caption    = font_caption,
    font_label      = font_label,
    font_legend     = font_legend,
    tick_length     = tick_length,
    gridline_width  = gridline_width,
    axis_line_width = axis_line_width,
    line_width      = line_width
  )
}


# -----------------------------------------------------------------------------
#' Truncate chart gridlines and axis at the last data point
#'
#' Sets \code{scale_x_continuous} or \code{scale_x_date} expansion to zero on
#' the right side and applies \code{coord_cartesian(clip = "off")} so that
#' gridlines stop at the final data point rather than extending to the edge of
#' the panel. This also provides space on the right for direct line labels
#' added by \code{label_lines()}.
#'
#' Works with both numeric and Date x-axis columns.
#'
#' @param data A data frame containing the chart data.
#' @param x_col Unquoted column name of the x-axis variable.
#' @param label_offset Numeric. Extra space added to the right of the last
#'   data point (in data units for numeric x, in days for Date x) to
#'   accommodate line labels. Default: 0 (no extra space; \code{label_lines}
#'   handles its own offset via \code{x_offset}).
#' @param left_expand Numeric. Fractional expansion on the left side of the
#'   x-axis. Default: 0 (starts at first data point).
#' @param ... Additional arguments passed to \code{scale_x_continuous} or
#'   \code{scale_x_date}.
#'
#' @return A list of ggplot2 layers (scale + coord).
#' @export
#'
#' @examples
#' fig + set_chart_limits(chart_dta, x_col = year)
#' fig + set_chart_limits(chart_dta, x_col = date)  # works with Date columns too
set_chart_limits <- function(data, x_col, label_offset = 0, left_expand = 0, ...) {
  x_vals <- data[[deparse(substitute(x_col))]]
  x_max  <- max(x_vals, na.rm = TRUE)
  
  is_date <- inherits(x_vals, "Date")
  
  if (is_date) {
    x_upper <- x_max + label_offset
    list(
      ggplot2::scale_x_date(
        expand = ggplot2::expansion(mult = c(left_expand, 0)),
        ...
      ),
      ggplot2::coord_cartesian(
        xlim = c(NA, x_upper),
        clip = "off"
      )
    )
  } else {
    x_upper <- x_max + label_offset
    list(
      ggplot2::scale_x_continuous(
        expand = ggplot2::expansion(mult = c(left_expand, 0)),
        ...
      ),
      ggplot2::coord_cartesian(
        xlim = c(NA, x_upper),
        clip = "off"
      )
    )
  }
}
#' Direct end-of-line labels with collision nudging
#'
#' Adds text labels at the terminal point of each line in a line chart,
#' positioned to the right of the final data point. Includes automatic
#' vertical nudging to prevent overlapping labels when lines converge at
#' similar y-values.
#'
#' Labels are always positioned at their corresponding line's final y value.
#' The \code{min_gap} nudge only activates when two labels would otherwise
#' overlap — if lines are well-separated, all labels sit exactly at their
#' endpoints and \code{min_gap} has no effect.
#'
#' Font size and family are read from the spec so they stay consistent across
#' all charts without per-chart overrides. Note: geom_text uses ggplot2
#' internal size units, so font_label is divided by \code{.pt} internally to
#' convert from points to the correct display size.
#'
#' @param data A data frame containing the chart data (the same data passed
#'   to \code{ggplot()}).
#' @param x_col Unquoted column name of the x-axis variable.
#' @param y_col Unquoted column name of the y-axis variable.
#' @param label_col Unquoted column name containing the label text.
#' @param color_col Unquoted column name used for color mapping. Should match
#'   the \code{color} aesthetic in your \code{aes()} so labels inherit the
#'   line colors automatically. If NULL, labels are drawn in black.
#' @param min_gap Numeric. Minimum vertical distance between labels in data
#'   units. If NULL (default), automatically calculated as 5% of the y-axis range.
#'   Increase if labels still overlap; decrease if labels are spread too far apart.
#' @param x_offset Numeric. Horizontal distance from the last data point to
#'   the label, in data units (or days for Date axes). Default: 0.3.
#' @param hjust Numeric. Horizontal justification of the label text.
#'   Default: 0 (left-aligned from the offset position).
#' @param lineheight Numeric. Line height for multi-line labels (0-2, where 1 is normal).
#'   If NULL (default), automatically calculated as 10.8 / font_label for
#'   typography-appropriate spacing. Decrease for tighter lines.
#' @param spec A spec list from \code{cori_chart_spec()}. Controls font size
#'   and family. If NULL, uses package defaults.
#'
#' @return A \code{geom_text} ggplot2 layer.
#' @export
#'
#' @examples
#' fig + label_lines(
#'   data      = chart_dta,
#'   x_col     = year,
#'   y_col     = avg_pci_index,
#'   label_col = category,
#'   color_col = category,
#'   min_gap   = 0.035
#' )
label_lines <- function(
    data,
    x_col,
    y_col,
    label_col,
    color_col = NULL,
    min_gap   = NULL,
    x_offset  = 0.3,
    hjust     = 0,
    lineheight = NULL,
    label_width = 12,
    spec      = NULL
) {
  if (is.null(spec)) spec <- cori_chart_spec()

  # Auto-calculate lineheight based on font size if not provided
  if (is.null(lineheight)) {
    lineheight = 8.1 / spec$font_label
  }

  # Capture column names as strings for tidy evaluation
  x_str     <- deparse(substitute(x_col))
  y_str     <- deparse(substitute(y_col))
  label_str <- deparse(substitute(label_col))
  color_str <- deparse(substitute(color_col))

  # Auto-calculate min_gap based on y-axis range if not provided
  if (is.null(min_gap)) {
    y_vals <- data[[y_str]]
    y_range <- max(y_vals, na.rm = TRUE) - min(y_vals, na.rm = TRUE)
    min_gap <- y_range / 20  # 5% of range
  }
  
  # Build label data: one row per line at the final x value
  label_data <- data[data[[x_str]] == max(data[[x_str]], na.rm = TRUE), ]
  label_data <- label_data[order(label_data[[y_str]]), ]

  # Wrap labels at specified width
  label_data[[label_str]] <- stringr::str_wrap(
    label_data[[label_str]],
    width = label_width
  )

  # Apply x offset for horizontal placement
  label_data[[x_str]] <- label_data[[x_str]] + x_offset
  
  # Store adjusted y positions; nudge upward to resolve overlaps
  label_data[["label_y"]] <- label_data[[y_str]]

  # Simple overlap prevention: nudge overlapping labels upward
  if (nrow(label_data) > 1) {
    for (i in 2:nrow(label_data)) {
      gap <- label_data[["label_y"]][i] - label_data[["label_y"]][i - 1]
      if (gap < min_gap) {
        label_data[["label_y"]][i] <- label_data[["label_y"]][i - 1] + min_gap
      }
    }
  }
  
  # Build aes: conditionally include color mapping.
  # Check the string only — avoids evaluating color_col as a bare variable
  # name in the calling environment where it would not be found.
  if (color_str != "NULL") {
    mapping <- ggplot2::aes(
      x     = .data[[x_str]],
      y     = .data[["label_y"]],
      label = .data[[label_str]],
      color = .data[[color_str]]
    )
  } else {
    mapping <- ggplot2::aes(
      x     = .data[[x_str]],
      y     = .data[["label_y"]],
      label = .data[[label_str]]
    )
  }
  
  # geom_text size uses ggplot2 internal units, so font_label must be
  # divided by .pt to convert from points to the correct display size.
  # This is different from element_text() which takes points directly.
  ggplot2::geom_text(
    data        = label_data,
    mapping     = mapping,
    hjust       = hjust,
    size        = spec$font_label / ggplot2::.pt,
    lineheight  = lineheight,
    fontface    = "bold",
    family      = "Lato",
    show.legend = FALSE
  )
}
