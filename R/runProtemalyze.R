#' Launch Shiny App for protemalyze
#'
#' A function that launches the Shiny app for protemalyze.
#' The purpose of this app is only to illustrate how a Shiny
#' app works. The code has been placed in \code{./inst/shiny-scripts}.
#'
#' @return None. Opens a Shiny webpage
#'
#' @examples
#' \dontrun{
#'
#' protemalyze::runProtemalyze()
#' }
#'
#' @export
#' @importFrom shiny runApp
#' @import dplyr
#' @importFrom plotly plot_ly layout
#' @import DT
runProtemalyze <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "protemalyze")
  actionShiny <- shiny::runApp(appDir, display.mode = "normal")
  return(actionShiny)
}
# [END]
