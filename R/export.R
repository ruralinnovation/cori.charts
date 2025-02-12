#' Add CORI logo to an image
#'
#' @param plot_path file path to the chart/plot/graphic
#' @param logo_path Path to the logo. Defaults to hosted Full CORI Black logo
#' @param logo_position Combination of top/bottom and right/left. Defaults to top right.
#' @param logo_scale Scale logo to 1/10 width of plot
#'
#' @return magick image
#'
#' @export
add_logo <- function(
  plot_path,
  logo_path = "https://rwjf-public.s3.amazonaws.com/Logo-Mark_CORI_Black.svg",
  logo_position = "top right",
  logo_scale = 20
) {

  # Requires magick R Package https://github.com/ropensci/magick

  # Useful error message for logo position
  if (!logo_position %in% c("top right", "top left", "bottom right", "bottom left")) {
    stop("Error Message: Uh oh! Logo Position not recognized\n  Try: logo_positon = 'top left', 'top right', 'bottom left', or 'bottom right'")
  }

  # read in raw images
  plot <- magick::image_read(plot_path)
  logo_raw <- magick::image_read_svg(logo_path)

  # get dimensions of plot for scaling
  plot_height <- magick::image_info(plot)$height
  plot_width <- magick::image_info(plot)$width

  # default scale to 1/10th width of plot
  # Can change with logo_scale
  logo <- magick::image_scale(logo_raw, as.character(plot_width/logo_scale))

  # Get width of logo
  logo_width <- magick::image_info(logo)$width
  logo_height <- magick::image_info(logo)$height

  # Set position of logo
  # Position starts at 0,0 at top left
  # Using 0.01 for 1% - aesthetic padding

  if (logo_position == "top right") {
    x_pos = plot_width - logo_width - 0.02 * plot_width
    y_pos = 0.015 * plot_width
  } else if (logo_position == "top left") {
    x_pos = 0.01 * plot_width
    y_pos = 0.01 * plot_height
  } else if (logo_position == "bottom right") {
    x_pos = plot_width - logo_width - 0.01 * plot_width
    y_pos = plot_height - logo_height - 0.01 * plot_height
  } else if (logo_position == "bottom left") {
    x_pos = 0.01 * plot_width
    y_pos = plot_height - logo_height - 0.01 * plot_height
  }

  # Compose the actual overlay
  magick::image_composite(plot, logo, offset = paste0("+", x_pos, "+", y_pos))

}

#' Add CORI logo to ggplot figure in an SVG-friendly way, then export
#' @description Specialty function for adding a CORI logo to a ggplot figure
#' in a way that can be exported as an SVG. You MUST set clip to "off" in a
#' coordinate function for this function to work.
#'
#' @param fig ggplot2 figure
#' @param export_path file path for the exported plot
#' @param logo_path Path to the logo. Defaults to hosted Full CORI Black logo
#' @param x_pos_scale Position scale factor as a percentage of x range
#' @param y_pos_scale Position scale factor as a percentage of the y range
#' @param chart_width The width in "in" of the chart
#' @param chart_height The height in "in" of the chart
#' @param units One of "in", "cm", "mm", or "px"
#' @param img_scale = Multiplicative scaling factor
#' @param background Color of the background in the image export
#'
#' @return ggplot figure with logo
#'
#' @export
save_with_logo_svg <- function(
  fig,
  export_path,
  logo_path = "https://rwjf-public.s3.amazonaws.com/Logo-Mark_CORI_Black.svg",
  x_pos_scale = .9975,
  y_pos_scale = 1.195,
  chart_width = 8.888889,
  chart_height = 6.25,
  units = "in",
  img_scale = 1,
  background = "white"
) {

  cori_logo_svg <- magick::image_read_svg(logo_path, width = 400)

  img <- grid::rasterGrob(
    cori_logo_svg,
    interpolate=TRUE,
    x = 1, y = 1,
    just = c('right', 'bottom'),
    height = grid::unit(37, 'pt')
  )

  fig_params <- ggplot2::ggplot_build(fig)

  y_range <- fig_params$layout$panel_params[[1]]$y.range
  x_range <- fig_params$layout$panel_params[[1]]$x.range

  # For maps, which have different object structure
  if (is.null(y_range)) {
    y_range <- fig_params$layout$panel_params[[1]]$y_range
  }

  if (is.null(x_range)) {
    x_range <- fig_params$layout$panel_params[[1]]$x_range
  }

  y_max <- y_range[[2]]
  x_max <- x_range[[2]]

  y_position <- y_pos_scale * y_max
  x_position <- x_pos_scale * x_max

  fig_with_logo <- fig +
    ggplot2::annotation_custom(img, xmin=x_position, xmax=x_position, ymin=y_position, ymax=y_position)

  ggplot2::ggsave(
    export_path,
    plot = fig_with_logo,
    bg = background,
    width = chart_width,
    height = chart_height,
    units = "in",
    scale = img_scale
  )

}

#' Save a plot with CORI defaults
#'
#' @param fig The ggplot2 figure
#' @param export_path file path for the exported plot
#' @param chart_width The width in "in" of the chart
#' @param chart_height The height in "in" of the chart
#' @param add_logo Boolean that determines if a logo is included or not
#' @param logo_position Combination of top/bottom and right/left. Defaults to top right.
#' @param logo_path Path to the logo. Defaults to hosted Full CORI Black logo
#' @param logo_scale Scale logo to 1/logo_scale width of plot
#' @param img_scale Multiplicative scaling factor
#' @param units One of "in", "cm", "mm", or "px"
#' @param background Color of the background in the image export
#'
#' @export
save_plot <- function(
  fig,
  export_path,
  chart_width = 8.888889,
  chart_height = 6.25,
  add_logo = TRUE,
  logo_position = "top right",
  logo_path = "https://rwjf-public.s3.amazonaws.com/Logo-Mark_CORI_Black.svg",
  logo_scale = 20,
  img_scale = 1,
  units = "in",
  background = "white"
) {

  ggplot2::ggsave(
    export_path,
    plot = fig,
    bg = background,
    width = chart_width,
    height = chart_height,
    units = "in",
    scale = img_scale
  )

  if (add_logo == TRUE) {
    fig_with_logo <- add_logo(
      export_path,
      logo_path = logo_path,
      logo_position = logo_position,
      logo_scale = logo_scale
    )

    magick::image_write(
      fig_with_logo,
      path = export_path
    )
  }

}


#' Pull chart text from Google Sheet and format it
#'
#' This function retrieves chart-related text from a Google Sheet and formats it.
#' It assumes that the spreadsheet contains the following columns: `viz_id`, `title`, `subtitle`, `source`, `note`, `x`, and `y`.
#'
#' @param sheet_id Character. The Google Sheets ID.
#' @param viz_unique_id Character. The unique visualization ID in the sheet.
#' @param title_wrap Integer. Character width for wrapping the title. Default is 150.
#' @param subtitle_wrap Integer. Character width for wrapping the subtitle. Default is 150.
#' @param caption_wrap Integer. Character width for wrapping the source and notes. Default is 80.
#'
#' @return A named list with elements: `title`, `subtitle` (if available), `x` (if available), `y` (if available), and `caption` (if available).
#' @export
#' @importFrom rlang .data
#' @importFrom googlesheets4 read_sheet
get_chart_text_from_gsheet <- function(
    sheet_id,
    viz_unique_id,
    title_wrap = 150,
    subtitle_wrap = 150,
    caption_wrap = 80
) {

  chart_entry <- googlesheets4::read_sheet(sheet_id) |>
    dplyr::filter(.data$viz_id == viz_unique_id)

  title <- chart_entry |>
    dplyr::pull(title) |>
    dplyr::nth(1) |>
    stringr::str_wrap(width = title_wrap)

  subtitle = chart_entry |>
    dplyr::pull(subtitle) |>
    dplyr::nth(1)

  x <- NA
  y <- NA

  if ("x" %in% colnames(chart_entry)) {
    x <- chart_entry |> dplyr::pull(x) |> dplyr::nth(1)
  }

  if ("y" %in% colnames(chart_entry)) {
    y <- chart_entry |> dplyr::pull(y) |> dplyr::nth(1)
  }

  source <- chart_entry |>
    dplyr::pull(source) |>
    dplyr::nth(1) |>
    stringr::str_wrap(width = caption_wrap)

  note <- chart_entry |>
    dplyr::pull(note) |>
    dplyr::nth(1) |>
    stringr::str_wrap(width = caption_wrap)

  if (is.na(source) & !is.na(note)) {
    caption <- note
  }
  else if (!is.na(source) & is.na(note)) {
    caption <- source
  }
  else if (is.na(source) & is.na(note)) {
    caption <- NA
  }
  else {
    caption <- paste(source, note, sep ="\n")
  }

  chart_text <- list(
    "title" = title,
    "x" = NULL,
    "y" = NULL
  )

  if (!is.null(subtitle)) {
    if (!is.na(subtitle)) {
      subtitle <- subtitle |>
        stringr::str_wrap(width = subtitle_wrap)

      chart_text <- c(chart_text, "subtitle" = subtitle)
    }
  }

  if (!is.na(x)) {
    chart_text[["x"]] <- x
  }

  if (!is.na(y)) {
    chart_text[["y"]] <- y
  }

  if (!is.na(caption)) {
    chart_text <- c(chart_text, "caption" = caption)
  }

  return(chart_text)
}


