#' Test, import, and register TT Hoves font
#'
#' You need to install the TT Hoves font locally to use the CORI theming.
#'
#' - `tthoves_test()` tests to see if the TT Hoves font is imported and
#' registered.
#' - `tthoves_install()` registers the TT Hoves font for use in R.
#'
#' @examples
#' cori_font
#' try(tthoves_test())
#' @rdname fonts
#' @export
#'
cori_font <- "TT Hoves"

#' @rdname fonts
#' @export
#'

tthoves_install <- function() {
  if (sum(grepl(cori_font, extrafont::fonts())) > 0) {
    "TT Hoves font is already imported and registered."
  } else {
    extrafont::font_import(pattern = "TT Hoves")
    extrafont::loadfonts()
    tthoves_test()
  }
}

#' @rdname fonts
#' @export
#'
tthoves_test <- function() {
  if (sum(grepl(cori_font, extrafont::fonts())) > 0) {
    rlang::inform("TT Hoves font is imported and registered.")
  } else {
    rlang::abort(c(
      "TT Hoves font is not imported and registered.",
      "Install the font on your computer.",
      "Import and register using `tthoves_install()`."
    ))
  }
}

