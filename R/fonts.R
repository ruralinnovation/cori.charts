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

#' @rdname fonts
#' @export
#'
load_fonts <- function() {

  # Loads Lato from the google font repository and adds it to sysfonts
  sysfonts::font_add_google("Lato")

  # Load Bitter
  sysfonts::font_add_google("Bitter")

  # Loads TT Hoves (has to be installed on your computer)
  sysfonts::font_add(
    "TT Hoves",
    regular = "TypeType - TT Hoves Regular.ttf",
    bold = "TypeType - TT Hoves Bold.ttf",
    italic = "TypeType - TT Hoves Italic.ttf",
    bolditalic = "TypeType - TT Hoves Bold Italic.ttf"
  )

  # Ensures that any newly opened graphics devices will use showtext to draw text
  showtext::showtext_auto()
  # Sets default density per inch for exports
  showtext::showtext_opts(dpi = 300)

}

