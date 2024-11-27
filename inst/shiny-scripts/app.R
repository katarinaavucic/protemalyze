# base template (include citation)
# https://shiny.posit.co/r/gallery/application-layout/tabsets/
# file upload (include citation)
# https://shiny.posit.co/r/gallery/widgets/file-upload/
# fluid row (include citation)
# https://shiny.posit.co/r/reference/shiny/1.8.0/fluidpage.html
# DT (include citation)
# https://shiny.posit.co/r/articles/build/datatables/

library(shiny)
library(plotly)
library(DT)
library(dplyr)

# Set the upload limit to 50MB
# source: https://mastering-shiny.org/action-transfer.html
options(shiny.maxRequestSize = 50 * 1024^2)


# Define UI for random distribution app ----
ui <- fluidPage(

  # App title ----
  titlePanel("Tabsets"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(
      # Input file for Embedding Matrix (required).
      fileInput("embeddingFile", "Input Embedding Matrix File",
                accept = c(".csv", ".tsv", ".h5")),

      # Input file for Mapping (optional).
      fileInput("mappingFile", "Optional: Input Mapping File",
                accept = c(".csv", ".tsv")),

      # Action button to run the analysis.
      actionButton(inputId = "runButton", label = "Run Analysis")

      # TODO: add inputs for specifying distance metrics, threads, etc.

    ),

    # Main panel for displaying outputs ----
    mainPanel(


      # Output tabset with UMAP, Pairs, and Mapping Analysis ----
      tabsetPanel(type = "tabs",
                  tabPanel("Embedding UMAP", plotlyOutput("umapPlot")),
                  tabPanel("Closest and Farthest Pairs", DTOutput("pairsTable")),
                  tabPanel("Mapping Ranks & Distances", fluidRow(
                    column(6,
                           h4("Distance and Rank Table"),
                           DTOutput("mappingTable")),
                    column(6,
                           h4("Distance Distribution"),
                           plotOutput("distPlot", height = "300px"),
                           h4("Rank Distribution"),
                           plotOutput("rankPlot", height = "300px"))))
      )
    )
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {

  # Reactive expression to load and process embedding matrix when file is uploaded.
  embeddingMatrix <- reactive({
    req(input$embeddingFile)
    # source: https://mastering-shiny.org/action-transfer.html
    fileType <- tools::file_ext(input$embeddingFile$name)
    embeddingMatrix <- loadEmbeddings(input$embeddingFile$datapath, fileType)
    embeddingMatrix <- processData(embeddingMatrix)
    return(embeddingMatrix)
  })

  # Reactive expression to process mapping file if uploaded.
  paralogMapping <- reactive({
    req(input$mappingFile)
    mapping <- read.csv(input$mappingFile$datapath)
    return(mapping)
  })

  # Run analysis when action button is clicked.
  observeEvent(input$runButton, {

    # Must do this to use the result of the reactive expression.
    embeddingMatrixData <- embeddingMatrix()

    # Render UMAP plot using the processed embedding matrix.
    # This takes the longest but is on the first page so we will perform this
    # as early as possible.
    output$umapPlot <- renderPlotly({
      visualizeEmbeddingUMAP(embeddingMatrixData)
    })

    # Generate necessary tables for general analysis.
    distMatrix <- generateDistanceMatrix(embeddingMatrixData)
    rankMatrix <- generateRankMatrix(distMatrix)
    closestPairs <- getClosestPairs(rankMatrix)
    farthestPairs <- getFarthestPairs(rankMatrix)

    # Merge closestPairs and farthestPairs on Protein.
    combinedPairsTable <- dplyr::left_join(closestPairs, farthestPairs,
                                           by = "Protein")

    # Render the closest and farthest pairs table.
    output$pairsTable <- renderDT({
      return(datatable(combinedPairsTable,
                       options = list(pageLength = 10,
                                      lengthMenu = c(10, 20, 50, 100))))
    })

    # Check if a mapping has been uploaded.
    mapping <- paralogMapping()

    # If no mapping, send message to user.
    if (is.null(mapping)) {
      return(h3("Upload a mapping to view mapping-specific analysis."))
    # If mapping, perform analysis.
    } else {
      # Generate necessary tables and plots for mapping analysis.
      mappingDistances <- getDistancesByMapping(distMatrix, mapping)
      mappingRanks <- getRanksByMapping(rankMatrix, mapping)
      distPlot <- visualizeDistanceDistribution(distMatrix, mapping)
      rankPlot <- visualizeRankDistribution(rankMatrix, mapping)

      # Merge mappingDistances and mappingRanks on Protein1 and Protein2
      combinedTable <- dplyr::left_join(mappingDistances, mappingRanks,
                                        by = c("Protein1", "Protein2"))

      # Render the distance and rank table for the mapping.
      output$mappingTable <- renderDT({
        return(datatable(combinedTable,
                         options = list(pageLength = 10,
                                        lengthMenu = c(10, 20, 50, 100))))
      })

      # Render distance distribution plot.
      output$distPlot <- renderPlot({
        return(visualizeDistanceDistribution(distMatrix, mapping))
      })

      # Render rank distribution plot.
      output$rankPlot <- renderPlot({
        return(visualizeRankDistribution(rankMatrix, mapping))
      })
    }
  })
}

# Create Shiny app ----
shinyApp(ui, server)
