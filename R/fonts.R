#' Functions for working with CORI fonts
#'
#' @rdname fonts
#'
#' @param fonts Character vector of Google font names to load.
#' @export
#'
load_fonts <- function(fonts = c("Lato", "Bitter")) {
  
  # Loop over each font and add from Google
  for (f in fonts) {
    sysfonts::font_add_google(f)
  }
  
  # Ensures that any newly opened graphics devices will use showtext to draw text
  showtext::showtext_auto()
  # Sets default density per inch for exports
  showtext::showtext_opts(dpi = 300)
}


