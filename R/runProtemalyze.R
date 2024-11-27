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
#' protemalyze::runProtemalyze()
#' }
#'
#' @references
#' Chang, W., Cheng, J., Allaire, J. J., Sievert, C., Scherer, L., & Wison, A.
#' (2022). Shiny: Web Application Framework for R. R package version 1.7.1.
#'
#' Wickham, H. (2018). Chapter 9 Uploads and downloads | Mastering Shiny.
#' Mastering-Shiny.org.
#'
#' Xie, Y. (2017, June 28). Shiny - How to use DataTables in a Shiny App. Shiny.
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
