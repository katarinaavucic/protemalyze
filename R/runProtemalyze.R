#' Launch Shiny App for protemalyze
#'
#' A function that launches the Shiny app for protemalyze.
#' The app provides an interactive interface for visualizing and analyzing
#' protein embeddings.
#'
#' @return None. Opens a Shiny application.
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
