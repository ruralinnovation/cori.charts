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
  logo_scale = 16
) {

  # Requires magick R Package https://github.com/ropensci/magick

  # Useful error message for logo position
  if (!logo_position %in% c("top right", "top left", "bottom right", "bottom left")) {
    stop("Error Message: Uh oh! Logo Position not recognized\n  Try: logo_positon = 'top left', 'top right', 'bottom left', or 'bottom right'")
  }

  # read in raw images
  plot <- magick::image_read(plot_path)
  logo_raw <- magick::image_read(logo_path)

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
    x_pos = plot_width - logo_width - 0.01 * plot_width
    y_pos = 0.01 * plot_width
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

#' Save a plot with CORI defaults
#'
#' @param fig The ggplot2 figure
#' @param export_path file path for the exported plot
#' @param chart_width The width in px of the chart
#' @param chart_height The height in px of the chart
#' @param add_logo Boolean that determines if a logo is included or not
#' @param logo_position Combination of top/bottom and right/left. Defaults to top right.
#' @param logo_path Path to the logo. Defaults to hosted Full CORI Black logo
#' @param logo_scale Scale logo to 1/10 width of plot
#'
#' @export
save_plot <- function(
  fig,
  export_path,
  chart_width = 640,
  chart_height = 450,
  add_logo = TRUE,
  logo_path = "https://rwjf-public.s3.amazonaws.com/Logo-Mark_CORI_Black.svg",
  logo_position = "top right",
  logo_scale = 16
) {

  ggplot2::ggsave(
    export_path,
    plot = fig,
    bg = "white",
    width = (chart_width/72),
    height = (chart_height/72)
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
