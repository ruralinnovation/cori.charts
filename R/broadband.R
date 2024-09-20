#' Update the bbox to align with a specified aspect ratio
#'
#' @param bbox Object of class bbox
#' @param target_aspect_ratio Aspect ratio to convert the bbox to, defaults to 7:4
#'
#' @return updated object of class bbox
#'
#' @export
fit_bbox_to_aspect_ratio <- function(bbox, target_aspect_ratio = 1.75) {

  width <- bbox["xmax"] - bbox["xmin"]
  height <- bbox["ymax"] - bbox["ymin"]
  current_aspect_ratio <- width / height

  if (current_aspect_ratio > target_aspect_ratio) {

    new_height <- width / target_aspect_ratio
    center_y <- mean(c(bbox["ymin"], bbox["ymax"]))
    bbox["ymin"] <- center_y - new_height / 2
    bbox["ymax"] <- center_y + new_height / 2

  } else {
    # Adjust width to match the aspect ratio
    new_width <- height * target_aspect_ratio
    center_x <- mean(c(bbox["xmin"], bbox["xmax"]))
    bbox["xmin"] <- center_x - new_width / 2
    bbox["xmax"] <- center_x + new_width / 2
  }

  return(bbox)

}



#' Add a scale and north arrow to a map
#'
#' @param fig ggplot map
#' @param data spatial data to use for drawing the scale
#' @param font_family font family to use for the scale label
#'
#' @return Updated ggplot figure
#'
#' @export
add_scale_and_north_arrow <- function(fig, data, font_family = "Bitter") {

  fig <- fig +
    ggspatial::annotation_scale(
      data = data,
      bar_cols = c(cori_colors["Nearly Black"], "white"),
      line_width = 0.2,
      unit_category = "imperial",
      pad_x = ggplot2::unit(0.675, "cm"),
      text_family = font_family
    ) +
    ggspatial::annotation_north_arrow(
      location = "br",
      pad_x = ggplot2::unit(0.25, "cm"),
      pad_y = ggplot2::unit(0.25, "cm"),
      style = ggspatial::north_arrow_minimal(
        line_width = .5,
        text_family = font_family,
        line_col = cori_colors["Nearly Black"],
        fill = cori_colors["Nearly Black"],
        text_col = cori_colors["Nearly Black"],
        text_size = 0
      )
    )

  return(fig)

}
