#' Add CORI logo to an image
#'
#' @param plot_path file path to the chart/plot/graphic. Must be a `.png` or
#'   `.svg` file; other file types raise an error.
#' @param logo_path Path to the logo. Defaults to hosted Full CORI Black logo
#' @param logo_position Combination of top/bottom and right/left. Defaults to top right.
#' @param logo_scale Scale logo to 1/10 width of plot
#' @param logo_margin Gap between the logo and the two borders it sits
#'   nearest, as a fraction of the plot's dimensions: a single number for
#'   both axes, or `c(x, y)` to set them separately (e.g. `0.05` for 5%, or
#'   `c(0.04, 0.06)`). Defaults to `NULL`, which keeps the padding this
#'   function has always used.
#' @param overwrite Boolean. If `plot_path` is an SVG file, the file is
#'   always updated in place with the logo embedded, regardless of this
#'   value. If `plot_path` is a PNG file, the file is only updated in place
#'   when `overwrite = TRUE`. Default `FALSE`.
#'
#' @return magick image
#'
#' @export
add_logo <- function(
  plot_path,
  logo_path = "https://rwjf-public.s3.amazonaws.com/Logo-Mark_CORI_Black.svg",
  logo_position = "top right",
  logo_scale = 20,
  logo_margin = NULL,
  overwrite = FALSE
) {

  # Useful error message for logo position
  if (!logo_position %in% c("top right", "top left", "bottom right", "bottom left")) {
    stop("Error Message: Uh oh! Logo Position not recognized\n  Try: logo_positon = 'top left', 'top right', 'bottom left', or 'bottom right'")
  }

  ext <- tolower(tools::file_ext(plot_path))
  if (!ext %in% c("png", "svg")) {
    stop("add_logo() only supports PNG or SVG files. Got: .", ext)
  }

  if (ext == "svg") {
    add_logo_svg(plot_path, logo_path, logo_position, logo_scale, logo_margin)
  } else {
    add_logo_png(plot_path, logo_path, logo_position, logo_scale, logo_margin, overwrite)
  }
}

#' Place a logo in one corner of a plot
#' @description Internal helper shared by [add_logo_png()] and
#' [add_logo_svg()] so the two formats cannot drift apart. Returns the
#' top-left corner the logo should be drawn at, in the same units as the
#' dimensions passed in (pixels for PNG, user units for SVG).
#' @inheritParams add_logo
#' @param plot_width,plot_height dimensions of the plot
#' @param logo_width,logo_height dimensions of the scaled logo
#' @return named numeric of length 2: `x` and `y`
#' @keywords internal
logo_offsets <- function(
  logo_position,
  plot_width,
  plot_height,
  logo_width,
  logo_height,
  logo_margin = NULL
) {

  if (is.null(logo_margin)) {
    # Padding this function has always applied, kept exactly so output is
    # unchanged when logo_margin is not supplied. "top right" is the odd one
    # out: it pads wider horizontally, and its vertical padding is a fraction
    # of the plot's WIDTH rather than its height.
    pads <- switch(
      logo_position,
      "top right"    = c(x = 0.02 * plot_width, y = 0.015 * plot_width),
      "top left"     = c(x = 0.01 * plot_width, y = 0.01 * plot_height),
      "bottom right" = c(x = 0.01 * plot_width, y = 0.01 * plot_height),
      "bottom left"  = c(x = 0.01 * plot_width, y = 0.01 * plot_height)
    )
  } else {
    if (!is.numeric(logo_margin) || !length(logo_margin) %in% 1:2 || anyNA(logo_margin)) {
      stop("logo_margin must be a numeric of length 1 or 2, as fractions of the plot's width and height.")
    }
    margin <- rep(logo_margin, length.out = 2)
    pads <- c(x = margin[[1]] * plot_width, y = margin[[2]] * plot_height)
  }

  c(
    x = if (grepl("right$", logo_position)) plot_width - logo_width - pads[["x"]] else pads[["x"]],
    y = if (grepl("^top", logo_position)) pads[["y"]] else plot_height - logo_height - pads[["y"]]
  )
}

#' Add CORI logo to a raster (PNG) image
#' @description Internal helper used by [add_logo()] when `plot_path` is a
#' PNG file. Composites the logo onto the raster image using magick.
#' @inheritParams add_logo
#' @return magick image
#' @keywords internal
add_logo_png <- function(plot_path, logo_path, logo_position, logo_scale, logo_margin, overwrite) {

  # Requires magick R Package https://github.com/ropensci/magick
  plot <- magick::image_read(plot_path)
  logo_raw <- magick::image_read_svg(logo_path)

  # get dimensions of plot for scaling
  plot_height <- magick::image_info(plot)$height
  plot_width <- magick::image_info(plot)$width

  # default scale to 1/10th width of plot
  # Can change with logo_scale
  logo <- magick::image_scale(logo_raw, as.character(plot_width / logo_scale))

  # Get width of logo
  logo_width <- magick::image_info(logo)$width
  logo_height <- magick::image_info(logo)$height

  # Set position of logo. Position starts at 0,0 at top left.
  offsets <- logo_offsets(logo_position, plot_width, plot_height, logo_width, logo_height, logo_margin)
  x_pos <- offsets[["x"]]
  y_pos <- offsets[["y"]]

  # Compose the actual overlay
  composited <- magick::image_composite(plot, logo, offset = paste0("+", x_pos, "+", y_pos))

  if (isTRUE(overwrite)) {
    magick::image_write(composited, path = plot_path)
  }

  composited
}

#' Resolve a logo's own styling onto its shape elements
#' @description Internal helper used by [add_logo_svg()]. CSS in the host
#' document reaches into an embedded `<svg>`: an svglite chart carries
#' `.svglite path { fill: none; stroke: #000000 }` on its root, which
#' outranks a logo's own `.st0 { fill: ... }` rule (specificity 0-1-1 beats
#' 0-1-0) and also outranks any `fill="..."` presentation attribute, leaving
#' the logo a hollow black outline. An inline `style` attribute outranks
#' every author rule whatever its selector, so each shape's resolved fill and
#' stroke are written inline before the logo is embedded.
#' @param logo_root the logo document's root `<svg>` node
#' @return `logo_root`, modified in place
#' @keywords internal
inline_logo_styles <- function(logo_root) {

  # Parse the simple `.class { prop: value; }` rules Illustrator and Figma
  # emit. Anything more exotic is left to the element's own attributes.
  style_text <- paste(
    xml2::xml_text(xml2::xml_find_all(logo_root, ".//*[local-name()='style']")),
    collapse = "\n"
  )

  class_decls <- list()
  for (rule in regmatches(style_text, gregexpr("[^{}]+\\{[^}]*\\}", style_text, perl = TRUE))[[1]]) {
    decls <- sub("\\}\\s*$", "", sub("^[^{]*\\{", "", rule))
    for (selector in trimws(strsplit(sub("\\{.*$", "", rule), ",")[[1]])) {
      if (grepl("^\\.[-_A-Za-z][-_A-Za-z0-9]*$", selector)) {
        class_decls[[sub("^\\.", "", selector)]] <- decls
      }
    }
  }

  # Pull one property out of a declaration list. The `[^-]` guard keeps
  # "fill" from matching "fill-opacity" (likewise stroke/stroke-width).
  css_value <- function(decls, prop) {
    hit <- regmatches(decls, regexpr(paste0("(^|;)\\s*", prop, "\\s*:\\s*[^;]+"), decls, perl = TRUE))
    if (length(hit) == 0L || !nzchar(hit)) return(NULL)
    trimws(sub(paste0("^.*?", prop, "\\s*:\\s*"), "", hit))
  }

  # Walk node -> logo_root. At each level inline style beats a class rule,
  # which beats a presentation attribute (that is the CSS cascade order).
  # fill and stroke both inherit, so an ancestor's value still counts.
  resolve_prop <- function(node, prop) {
    cur <- node
    repeat {
      inline <- xml2::xml_attr(cur, "style")
      if (!is.na(inline)) {
        val <- css_value(inline, prop)
        if (!is.null(val)) return(val)
      }

      classes <- xml2::xml_attr(cur, "class")
      if (!is.na(classes)) {
        for (cls in strsplit(trimws(classes), "\\s+")[[1]]) {
          if (!is.null(class_decls[[cls]])) {
            val <- css_value(class_decls[[cls]], prop)
            if (!is.null(val)) return(val)
          }
        }
      }

      attr_val <- xml2::xml_attr(cur, prop)
      if (!is.na(attr_val)) return(attr_val)

      if (identical(xml2::xml_path(cur), xml2::xml_path(logo_root))) return(NULL)
      cur <- xml2::xml_parent(cur)
      if (inherits(cur, "xml_missing")) return(NULL)
    }
  }

  shapes <- xml2::xml_find_all(
    logo_root,
    ".//*[local-name()='path' or local-name()='polygon' or local-name()='polyline' or
          local-name()='rect' or local-name()='circle' or local-name()='ellipse' or
          local-name()='line']"
  )

  for (node in shapes) {
    fill <- resolve_prop(node, "fill")
    stroke <- resolve_prop(node, "stroke")

    # SVG initial values, applied only when the logo itself says nothing
    if (is.null(fill)) fill <- "#000000"
    if (is.null(stroke)) stroke <- "none"

    decls <- c(paste0("fill:", fill), paste0("stroke:", stroke))
    if (!identical(tolower(stroke), "none")) {
      stroke_width <- resolve_prop(node, "stroke-width")
      if (!is.null(stroke_width)) decls <- c(decls, paste0("stroke-width:", stroke_width))
    }

    existing <- xml2::xml_attr(node, "style")
    keep <- if (is.na(existing)) character() else trimws(strsplit(existing, ";")[[1]])
    keep <- keep[nzchar(keep)]
    decls <- decls[!sub("\\s*:.*$", "", decls) %in% sub("\\s*:.*$", "", keep)]

    xml2::xml_set_attr(node, "style", paste(c(keep, decls), collapse = ";"))
  }

  logo_root
}

#' Add CORI logo to an SVG chart without rasterizing
#' @description Internal helper used by [add_logo()] when `plot_path` is an
#' SVG file. Overlays the logo as a nested `<svg>` element inside the plot's
#' root `<svg>` element (the standard technique for embedding one vector
#' document inside another), so the chart's vector paths and text are
#' preserved rather than rasterized or traced. Always writes the result back
#' to `plot_path`, since there is no way to produce a true vector SVG output
#' via any raster round trip.
#' @inheritParams add_logo
#' @return magick image (a rasterized preview of the updated file; the
#'   persisted file at `plot_path` remains fully vector)
#' @keywords internal
add_logo_svg <- function(plot_path, logo_path, logo_position, logo_scale, logo_margin) {

  plot_doc <- xml2::read_xml(plot_path)
  logo_doc <- xml2::read_xml(logo_path)

  plot_root <- xml2::xml_root(plot_doc)
  logo_root <- xml2::xml_root(logo_doc)

  # Get width/height in the SVG's own user-unit coordinate system.
  # Prefer viewBox (unit-agnostic, and it's the actual coordinate space the
  # SVG's own content is drawn in); fall back to width/height attrs with any
  # trailing unit suffix (pt, px, in, cm, mm, %) stripped.
  get_dims <- function(root) {
    vb <- xml2::xml_attr(root, "viewBox")
    if (!is.na(vb)) {
      parts <- as.numeric(strsplit(trimws(vb), "\\s+")[[1]])
      return(c(width = parts[3], height = parts[4]))
    }
    c(
      width  = as.numeric(gsub("[a-zA-Z%]+$", "", xml2::xml_attr(root, "width"))),
      height = as.numeric(gsub("[a-zA-Z%]+$", "", xml2::xml_attr(root, "height")))
    )
  }

  plot_dims   <- get_dims(plot_root)
  plot_width  <- plot_dims[["width"]]
  plot_height <- plot_dims[["height"]]

  logo_dims <- get_dims(logo_root)

  # default scale to 1/logo_scale width of plot, preserving logo aspect ratio
  logo_width  <- plot_width / logo_scale
  logo_height <- logo_width * (logo_dims[["height"]] / logo_dims[["width"]])

  # Set position of logo (same helper as add_logo_png(); SVG's y-axis also
  # starts top-left)
  offsets <- logo_offsets(logo_position, plot_width, plot_height, logo_width, logo_height, logo_margin)
  x_pos <- offsets[["x"]]
  y_pos <- offsets[["y"]]

  # Turn the logo's root <svg> into a nested SVG viewport: setting
  # x/y/width/height (unitless, i.e. in the parent's user-unit coordinate
  # system) on a child <svg> element embeds it as its own vector document
  # without rasterizing either the plot or the logo.
  xml2::xml_set_attr(logo_root, "x", as.character(x_pos))
  xml2::xml_set_attr(logo_root, "y", as.character(y_pos))
  xml2::xml_set_attr(logo_root, "width", as.character(logo_width))
  xml2::xml_set_attr(logo_root, "height", as.character(logo_height))

  # Immunize the logo against the host chart's stylesheet before embedding:
  # svglite's `.svglite path { fill: none; stroke: #000000 }` would otherwise
  # reach into the nested <svg> and strip the logo down to a hollow outline.
  inline_logo_styles(logo_root)

  # Cross-document insertion: xml_add_child()'s default `.copy = TRUE`
  # deep-copies logo_root's subtree into plot_doc; logo_doc is untouched.
  # This also preserves logo_root's original xmlns declaration automatically
  # -- do NOT xml_set_attr(logo_root, "xmlns", ...) here, it segfaults R
  # whenever the node already carries that namespace from parsing (always
  # true for a read_xml()'d SVG root).
  xml2::xml_add_child(plot_root, logo_root)

  # SVG output must always be persisted in place: it's the only way to get a
  # valid vector artifact with the logo embedded (magick cannot write true
  # vector SVG at all).
  xml2::write_xml(plot_doc, file = plot_path)

  # Return a magick image to honor add_logo()'s existing return contract
  # uniformly across input types: re-read the just-written file (now with
  # the embedded vector logo) via the rsvg-backed renderer as a
  # high-quality preview object, distinct from the persisted vector file.
  magick::image_read_svg(plot_path)
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


