# base template (include citation)
# https://shiny.posit.co/r/gallery/application-layout/tabsets/
# file upload (include citation)
# https://shiny.posit.co/r/gallery/widgets/file-upload/
# fluid row (include citation)
# https://shiny.posit.co/r/reference/shiny/1.8.0/fluidpage.html
# DT (include citation)
# https://shiny.posit.co/r/articles/build/datatables/
# downlaod
# https://shiny.posit.co/r/reference/shiny/0.11/downloadhandler.html
# retrieving file type source
# https://mastering-shiny.org/action-transfer.html

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
  titlePanel("protemalyze"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(width = 3,
      # Input file for Embedding Matrix (required).
      fileInput("embeddingFile", "Input Embedding Matrix File",
                accept = c(".csv", ".tsv", ".h5")),

      # Input file for Mapping (optional).
      fileInput("mappingFile", "Optional: Input Mapping File",
                accept = c(".csv", ".tsv")),

      # TODO: add inputs for specifying distance metrics, threads, etc.

      # Checkbox for showing additional parameters.
      checkboxInput("showDistanceParams",
                    "Show Parameters For Distance Matrix Calculations",
                    value = FALSE),

      # Conditional panel for additional distance matrix parameters.
      conditionalPanel(
        condition = "input.showDistanceParams == true",
        # Input for distance metric.
        textInput("distMetric", "Distance Metric", value = "euclidean"),
        # Input for number of threads.
        numericInput("numThreads", "Number of Threads", value = NULL),
        p("It is reccomended that you keep the number of threads as the default,
          which automatically uses all available threads.")
      ),

      # Action button to run the analysis.
      actionButton(inputId = "runButton", label = "Run Analysis")
    ),

    # Main panel for displaying outputs ----
    mainPanel(


      # Output tabset with UMAP, Pairs, and Mapping Analysis ----
      tabsetPanel(type = "tabs",
                  tabPanel("Embedding UMAP", plotlyOutput("umapPlot")),
                  tabPanel("Closest and Farthest Pairs", fluidRow(
                    h3("Closest and Farthest Pairs Table"),
                    downloadLink('downloadPairs', 'Download Table'),
                    DTOutput("pairsTable"))),
                  tabPanel("Mapping Ranks & Distances",
                           uiOutput("mappingTabContent"))
      )
    )
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {

  # Reactive expression to load and process embedding matrix when file is uploaded.
  embeddingMatrix <- reactive({
    req(input$embeddingFile)
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
        return(visualizeEmbeddingUMAP(embeddingMatrixData))
      })

      # Check if numThreads is a valid option
      if (is.integer(input$numThreads)) {
        threads <- input$numThreads
      } else {
        threads <- NULL
      }

      # Generate necessary tables for general analysis.
      distMatrix <- generateDistanceMatrix(embeddingMatrixData,
                                           metric=input$distMetric,
                                           threads=threads)
      rankMatrix <- generateRankMatrix(distMatrix)
      closestPairs <- getClosestPairs(rankMatrix)
      farthestPairs <- getFarthestPairs(rankMatrix)

      # Merge closestPairs and farthestPairs on Protein.
      combinedPairsTable <- dplyr::left_join(closestPairs, farthestPairs,
                                             by = "Protein")

      # Return button to download the table.
      output$downloadPairs <- downloadHandler(
        filename = function() {
          paste('closest_and_farthest_pairs_', Sys.Date(), '.csv', sep='')
        },
        content = function(file) {
          write.csv(combinedPairsTable, file)
        }
      )

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
        combinedMappingTable <- dplyr::left_join(mappingDistances, mappingRanks,
                                                 by = c("Protein1", "Protein2"))

        # Return button to download the table.
        output$downloadMapping <- downloadHandler(
          filename = function() {
            paste('mapping_distances_and_ranks_', Sys.Date(), '.csv', sep='')
          },
          content = function(file) {
            write.csv(combinedMappingTable, file)
          }
        )

        # Render the distance and rank table for the mapping.
        output$mappingTable <- renderDT({
          return(datatable(combinedMappingTable,
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

        # Reactive value to check if mapping file is uploaded
        mappingUploaded <- reactive({
          !is.null(input$mappingFile)
        })

        # Render the content of the Mapping tab conditionally
        output$mappingTabContent <- renderUI({
          if (mappingUploaded()) {
            fluidRow(
              column(12,
                     h3("Distance and Rank Table"),
                     downloadLink('downloadMapping', 'Download Table')
              ),
              column(6,
                     DTOutput("mappingTable")
              ),
              column(6,
                     h4("Distance Distribution"),
                     plotOutput("distPlot", height = "300px"),
                     h4("Rank Distribution"),
                     plotOutput("rankPlot", height = "300px")
              )
            )
          } else {
            p("No mapping file uploaded.
              Please upload a mapping file to see the analysis.")
          }

        })
      }
  })
}

# Create Shiny app ----
shinyApp(ui, server)
