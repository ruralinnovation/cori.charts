# theme_cori_precise.R
#
# Precision extension for the cori.charts package.
#
# This file adds five new functions on top of the existing cori.charts
# infrastructure. Nothing in the existing package is changed. All existing
# theme and save functions continue to work as before.
#
# What this adds:
#   1. cori_chart_spec()     — a constants object with package defaults
#   2. theme_cori_precise()  — physically-locked theme (pt/mm units throughout)
#   3. set_chart_limits()    — truncates gridlines at the last data point
#   4. label_lines()         — direct end-of-line labeling with collision nudging
#   5. save_chart()          — upgraded export wrapper (ragg PNG + svglite SVG)
#
# Why physically-locked units matter:
#   The existing theme uses base_size = 15 as a relative multiplier, which
#   means the same size value produces different physical output at different
#   canvas dimensions. By setting all element_text() sizes directly in points
#   and all line widths in mm, these functions produce identical physical
#   output regardless of canvas size. A 8pt label is always 8pt.
#
#   Note on ggplot2 size units:
#   - element_text(size = x) takes x directly in points — no conversion needed
#   - geom_text(size = x) uses ggplot2 internal units — requires x / .pt to
#     convert from points to the correct display size
#
# Dependencies to add to DESCRIPTION if not already present:
#   ragg, svglite
#
# Usage:
#   fig <- data |>
#     ggplot(aes(...)) +
#     geom_line(...) +
#     label_lines(data, x_col = year, y_col = value, label_col = category) +
#     set_chart_limits(data, x_col = year) +
#     scale_color_manual(...) +
#     theme_cori_precise(type = "line") +
#     labs(...)
#
#   save_chart(fig, "export/my_chart", preset = "report")


# -----------------------------------------------------------------------------
# 1. cori_chart_spec()
# -----------------------------------------------------------------------------

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
# 2. theme_cori_precise()
# -----------------------------------------------------------------------------

#' Physically-locked CORI ggplot2 theme
#'
#' A precision extension of the existing CORI themes. Calls the appropriate
#' base theme (\code{theme_cori_line}, \code{theme_cori_horizontal_bars}, etc.)
#' then overrides all size and width values with physically-locked units:
#' font sizes directly in points (element_text takes points natively),
#' line widths in mm, and tick lengths as explicit \code{unit()} calls.
#'
#' This means a 8pt axis label is always 8pt regardless of canvas dimensions,
#' eliminating the need for post-export Figma corrections.
#'
#' The subtitle is styled italic and positioned above the panel, consistent
#' with the CORI convention of using \code{labs(subtitle = ...)} to describe
#' the y-axis rather than a rotated axis title.
#'
#' @param type Character. Chart type, controls which base theme is called and
#'   which gridlines are shown. One of \code{"line"}, \code{"bar"},
#'   \code{"scatter"}, or \code{"map"}. Default: \code{"line"}.
#' @param preset Character. Chart output preset. One of \code{"report"}
#'   (6.5" width, font_caption = 8) or \code{"slide"} (4.75" width,
#'   font_caption = 6). Default: \code{"report"}.
#' @param spec A spec list from \code{cori_chart_spec()}. If NULL, uses
#'   preset-specific defaults (report or slide).
#' @param title_family Character. Font family for title and subtitle.
#'   Default: \code{"Lato"}.
#' @param base_family Character. Font family for all other text.
#'   Default: \code{"Lato"}.
#'
#' @return A ggplot2 theme object.
#' @export
#'
#' @examples
#' fig + theme_cori_precise(type = "line")
#' fig + theme_cori_precise(type = "bar", preset = "slide")
#' fig + theme_cori_precise(type = "scatter")
#' fig + theme_cori_precise(type = "line", spec = cori_chart_spec(font_axis = 7))
theme_cori_precise <- function(
    type         = "line",
    preset       = "report",
    spec         = NULL,
    title_family = "Lato",
    base_family  = "Lato"
) {
  # Define preset-specific spec defaults
  preset_specs <- list(
    report = cori_chart_spec(
      width_report    = 6.5,
      width_slide     = 4.75,
      dpi             = 300,
      aspect_ratio    = 0.625,
      font_title      = 12,
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
    ),
    slide = cori_chart_spec(
      width_report    = 6.5,
      width_slide     = 4.75,
      dpi             = 300,
      aspect_ratio    = 0.65,
      font_title      = 11,
      font_subtitle   = 9,
      font_axis       = 8,
      font_axis_title = 8,
      font_caption    = 6,
      font_label      = 9,
      font_legend     = 9,
      tick_length     = 4,
      gridline_width  = 0.25,
      axis_line_width = 0.4,
      line_width      = 1
    )
  )

  # If no spec provided, use preset default
  if (is.null(spec)) spec <- preset_specs[[preset]]

  # Set default line width for line geoms based on spec
  ggplot2::update_geom_defaults("line", list(linewidth = spec$line_width))

  black <- "#121E22"
  gray  <- "#d0d2ce"
  
  # Call appropriate base theme at a neutral base_size.
  # We override all sizes explicitly below, so base_size here is just
  # a starting scaffold — the value doesn't propagate to final output.
  base <- switch(
    type,
    "line"    = theme_cori_line(title_family = title_family, base_family = base_family, base_size = 11),
    "bar"     = theme_cori_horizontal_bars(title_family = title_family, base_family = base_family, base_size = 11),
    "scatter" = theme_cori_scatter(title_family = title_family, base_family = base_family, base_size = 11),
    "map"     = theme_cori_map(title_family = title_family, base_family = base_family, base_size = 11),
    stop("type must be one of: 'line', 'bar', 'scatter', 'map'")
  )
  
  # element_text(size = x) takes x directly in points — no conversion needed.
  # This is different from geom_text(size = x) which uses internal ggplot2
  # units and requires division by .pt to convert from points.
  precision_overrides <- ggplot2::theme(
    
    # --- Plot titles ---------------------------------------------------------
    plot.title = ggplot2::element_text(
      family     = title_family,
      size       = spec$font_title,
      face       = "bold",
      color      = black,
      hjust      = 0,
      lineheight = 1.1,
      margin     = ggplot2::margin(b = 8)
    ),
    plot.title.position = "plot",
    
    # Subtitle is italic, used as y-axis descriptor per CORI convention
    plot.subtitle = ggplot2::element_text(
      family     = title_family,
      size       = spec$font_subtitle,
      face       = "italic",
      color      = black,
      hjust      = 0,
      lineheight = 1.1,
      margin     = ggplot2::margin(b = 10)
    ),
    
    plot.caption = ggplot2::element_text(
      family     = base_family,
      size       = spec$font_caption,
      color      = black,
      hjust      = 0,
      lineheight = 1.2,
      margin     = ggplot2::margin(t = 10)
    ),
    plot.caption.position = "plot",
    
    # Right margin is wider to give line labels room to breathe.
    # font_title * 5 (~65pt at default 13pt title) accommodates most labels.
    # Override per-chart with theme(plot.margin = ...) if labels still clip.
    plot.margin = ggplot2::margin(
      t = 13,
      r = spec$font_title * 5,
      b = 13,
      l = 13,
      unit = "pt"
    ),
    
    # --- Axis text -----------------------------------------------------------
    axis.text.x = ggplot2::element_text(
      family = base_family,
      size   = spec$font_axis,
      color  = black,
      hjust  = 0.5,
      margin = ggplot2::margin(t = 3)
    ),
    axis.text.y = ggplot2::element_text(
      family = base_family,
      size   = spec$font_axis,
      color  = black,
      hjust  = 1,
      margin = ggplot2::margin(r = 3)
    ),
    axis.text.y.right = ggplot2::element_text(
      family = base_family,
      size   = spec$font_axis,
      color  = black,
      hjust  = 0,
      margin = ggplot2::margin(l = 6)
    ),
    
    # --- Axis titles ---------------------------------------------------------
    # Per CORI convention, y-axis title is usually NULL and the subtitle
    # is used instead. axis.title is kept here for charts that do use it.
    axis.title.x = ggplot2::element_text(
      family = base_family,
      size   = spec$font_axis_title,
      face   = "italic",
      color  = black,
      hjust  = 0.5,
      margin = ggplot2::margin(t = 8)
    ),
    axis.title.y = ggplot2::element_text(
      family = base_family,
      size   = spec$font_axis_title,
      face   = "italic",
      color  = black,
      hjust  = 0.5,
      angle  = 90,
      margin = ggplot2::margin(r = 8)
    ),
    
    # --- Axis ticks ----------------------------------------------------------
    axis.ticks.x = ggplot2::element_line(
      color     = gray,
      linewidth = spec$axis_line_width,
      linetype  = "solid"
    ),
    axis.ticks.y        = ggplot2::element_blank(),
    axis.ticks.length.x = ggplot2::unit(spec$tick_length, "pt"),
    axis.ticks.length.y.right = ggplot2::unit(0, "pt"),
    
    # --- Gridlines -----------------------------------------------------------
    # Gridline width is set in mm for physical consistency.
    panel.grid.major.y = ggplot2::element_line(
      color     = gray,
      linewidth = spec$gridline_width,
      linetype  = "solid"
    ),
    panel.grid.minor = ggplot2::element_blank(),
    
    # --- Legend --------------------------------------------------------------
    legend.text = ggplot2::element_text(
      family = base_family,
      size   = spec$font_legend,
      color  = black,
      vjust  = 0.5
    ),
    legend.key.size  = ggplot2::unit(spec$font_legend, "pt"),
    legend.spacing.y = ggplot2::unit(6, "pt"),
    legend.spacing.x = ggplot2::unit(4, "pt")
  )
  
  # For scatter charts, also show vertical gridlines
  if (type == "scatter") {
    precision_overrides <- precision_overrides + ggplot2::theme(
      panel.grid.major.x = ggplot2::element_line(
        color     = gray,
        linewidth = spec$gridline_width,
        linetype  = "solid"
      )
    )
  }
  
  base + precision_overrides
}


# -----------------------------------------------------------------------------
# 3. set_chart_limits()
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


# -----------------------------------------------------------------------------
# 4. label_lines()
# -----------------------------------------------------------------------------

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


# -----------------------------------------------------------------------------
# 5. save_chart()
# -----------------------------------------------------------------------------

#' Export a ggplot2 chart at precise physical dimensions
#'
#' A drop-in replacement for the existing \code{save_plot()} function that
#' adds preset-based width control, forced \code{ragg} and \code{svglite}
#' backends for physically-accurate rendering, and single-call multi-format
#' export.
#'
#' Canvas dimensions are always derived from the spec: width comes from the
#' preset, height from \code{width * spec$aspect_ratio}. This ensures the
#' aspect ratio is consistent across every chart in a report without manual
#' height specification.
#'
#' The logo compositing behavior matches the existing \code{save_plot()}
#' implementation (magick-based, PNG only). SVG exports do not receive a logo
#' because SVG compositing requires rasterization.
#'
#' @param fig A ggplot2 plot object.
#' @param path Character. Export path without file extension (the extension is
#'   added automatically based on \code{formats}).
#'   Example: \code{"export/pc_income_by_rurality"}.
#' @param preset Character. Canvas width preset. One of \code{"report"}
#'   (6.5", for Word documents) or \code{"slide"} (4.75", for PowerPoint).
#'   Default: \code{"report"}.
#' @param formats Character vector. File formats to export. Any combination of
#'   \code{"png"} and \code{"svg"}. Default: \code{c("png", "svg")}.
#' @param add_logo Logical. Whether to composite the CORI logo onto PNG output.
#'   Has no effect on SVG output. Default: \code{TRUE}.
#' @param logo_position Character. Logo position passed to \code{add_logo()}.
#'   Default: \code{"top right"}.
#' @param logo_path Character. URL or path to logo file. Defaults to the
#'   standard CORI logo used in \code{save_plot()}.
#' @param logo_scale Numeric. Logo scale passed to \code{add_logo()}.
#'   Default: 20.
#' @param aspect_ratio Numeric. Override the aspect ratio from the spec.
#'   If NULL, uses \code{spec$aspect_ratio}. Default: NULL.
#' @param spec A spec list from \code{cori_chart_spec()}. If NULL, uses
#'   preset-specific defaults (report or slide).
#' @param background Character. Background color. Default: \code{"white"}.
#'
#' @return Invisibly returns the file path(s) written.
#' @export
#'
#' @examples
#' # Standard report export (PNG + SVG at 6.5" wide)
#' save_chart(fig, "export/my_chart", preset = "report")
#'
#' # Slide export, PNG only, no logo
#' save_chart(fig, "export/my_chart", preset = "slide",
#'            formats = "png", add_logo = FALSE)
#'
#' # Custom aspect ratio
#' save_chart(fig, "export/my_chart", preset = "report", aspect_ratio = 0.5)
save_chart <- function(
    fig,
    path,
    preset        = "report",
    formats       = c("png", "svg"),
    add_logo      = TRUE,
    logo_position = "top right",
    logo_path     = "https://rwjf-public.s3.amazonaws.com/Logo-Mark_CORI_Black.svg",
    logo_scale    = 20,
    aspect_ratio  = NULL,
    spec          = NULL,
    background    = "white"
) {
  # Define preset-specific spec defaults
  preset_specs <- list(
    report = cori_chart_spec(
      width_report    = 6.5,
      width_slide     = 4.75,
      dpi             = 300,
      aspect_ratio    = 0.625,
      font_title      = 12,
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
    ),
    slide = cori_chart_spec(
      width_report    = 6.5,
      width_slide     = 4.75,
      dpi             = 300,
      aspect_ratio    = 0.65,
      font_title      = 11,
      font_subtitle   = 9,
      font_axis       = 8,
      font_axis_title = 8,
      font_caption    = 6,
      font_label      = 9,
      font_legend     = 9,
      tick_length     = 4,
      gridline_width  = 0.25,
      axis_line_width = 0.4,
      line_width      = 1
    )
  )

  # If no spec provided, use preset default
  if (is.null(spec)) spec <- preset_specs[[preset]]
  
  # Resolve canvas dimensions
  width <- switch(
    preset,
    "report" = spec$width_report,
    "slide"  = spec$width_slide,
    stop("preset must be 'report' or 'slide'")
  )
  
  ar     <- if (!is.null(aspect_ratio)) aspect_ratio else spec$aspect_ratio
  height <- width * ar
  
  paths_written <- character(0)
  
  # --- PNG export -----------------------------------------------------------
  if ("png" %in% formats) {
    png_path <- paste0(path, ".png")
    
    ragg::agg_png(
      filename   = png_path,
      width      = width,
      height     = height,
      units      = "in",
      res        = spec$dpi,
      background = background
    )
    print(fig)
    grDevices::dev.off()
    
    if (add_logo) {
      fig_with_logo <- add_logo(
        plot_path     = png_path,
        logo_path     = logo_path,
        logo_position = logo_position,
        logo_scale    = logo_scale
      )
      magick::image_write(fig_with_logo, path = png_path)
    }
    
    paths_written <- c(paths_written, png_path)
    message("Saved PNG: ", png_path)
  }
  
  # --- SVG export -----------------------------------------------------------
  if ("svg" %in% formats) {
    svg_path <- paste0(path, ".svg")
    
    svglite::svglite(
      file   = svg_path,
      width  = width,
      height = height,
      bg     = background
    )
    print(fig)
    grDevices::dev.off()
    
    paths_written <- c(paths_written, svg_path)
    message("Saved SVG: ", svg_path)
  }
  
  invisible(paths_written)
}