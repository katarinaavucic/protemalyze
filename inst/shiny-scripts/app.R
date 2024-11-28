
library(shiny)
library(plotly)
library(DT)
library(dplyr)

# Set the upload limit to 50MB
# References https://mastering-shiny.org/action-transfer.html
options(shiny.maxRequestSize = 50 * 1024^2)


# Define UI for random distribution app ----
ui <- fluidPage(

  # App title ----
  titlePanel("protemalyze"),

  p("protemalyze is an R package designed to analyze protein embeddings derived
    from protein Language Models (pLMs). Protein embeddings are numerical
    representations of protein sequences, where each protein is mapped to a
    fixed-length vector in a high-dimensional space. Run protemalyze on your
    own embedding matrix or use our pre-built example."),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(width = 3,
      # Input file for Embedding Matrix (required).
      h4("Embedding Matrix"),
      p("An embedding matrix generated from a protein Language Model in a csv,
        tsv, or h5 file. The embedding matrix must have proteins in the rows
        with the identifier in the index and embedding dimensions in the
        columns. If stored in an h5 file, this function assumes each row is a
        dataset under the root path."),
      downloadButton("downloadExampleEmbeddings",
                     "Download Example"),
      # Refrences https://shiny.posit.co/r/gallery/widgets/file-upload/
      fileInput("embeddingFile", "Input Embedding Matrix File",
                accept = c(".csv", ".tsv", ".h5")),

      # Input file for Mapping (optional).
      h4("Mapping (Optional)"),
      p("A table with two columns of protein identifiers matching the
        identifiers used for the embedding matrix in a csv file."),
      downloadButton("downloadExampleMapping",
                     "Download Example"),
      # Refrences https://shiny.posit.co/r/gallery/widgets/file-upload/
      fileInput("mappingFile", "Optional: Input Mapping File",
                accept = c(".csv")),


      # Checkbox for showing additional parameters.
      checkboxInput("showDistanceParams",
                    "Show Parameters For Distance Matrix Calculations",
                    value = FALSE),

      # Conditional panel for additional distance matrix parameters.
      conditionalPanel(
        condition = "input.showDistanceParams == true",

        # Input for distance metric.
        textInput("distMetric", "Distance Metric", value = "euclidean"),
        p("The metric to use for the distance matrix calculation. Valid metrics
          are: bhjattacharyya, bray, canberra, chord, divergence, dtw,
          euclidean, fJaccard, geodesic, hellinger, kullback, mahalanobis,
          maximum, minkowski, podani, soergel, wave, whittaker, binary,
          braun-blanquet, dice, fager, faith, hamman, kulczynski1, kulczynski2,
          michael, mountford, mozley, ochiai, phi, russel, simple matching,
          simpson, stiles, tanimoto, yule, yule2, cosine, hamming"),

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
      # Refrences https://shiny.posit.co/r/gallery/application-layout/tabsets/
      tabsetPanel(type = "tabs",
                  tabPanel("Embedding UMAP", plotlyOutput("umapPlot")),
                  # Fluid row allows for formatting of items within a panel
                  # References
                  #https://shiny.posit.co/r/reference/shiny/1.8.0/fluidpage.html
                  tabPanel("Closest and Farthest Pairs", fluidRow(
                    h3("Closest and Farthest Pairs Table"),
                    downloadLink('downloadPairs', 'Download Table'),
                    DTOutput("pairsTable"))),
                  tabPanel("Mapping Ranks & Distances",
                           uiOutput("mappingTabContent"))
      )
    ),
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {

  # Reactive expression to load and process embedding matrix when file is uploaded.
  embeddingMatrix <- reactive({
    req(input$embeddingFile)
    # References https://mastering-shiny.org/action-transfer.html
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

  # Return button to download the example embedding matrix.
  # References
  # https://shiny.posit.co/r/reference/shiny/0.11/downloadhandler.html
  output$downloadExampleEmbeddings <- downloadHandler(
    filename = function() {
      paste('SARSCoV2EmbeddingMatrix', Sys.Date(), '.csv', sep='')
    },
    content = function(file) {
      write.csv(SARSCoV2EmbeddingMatrix, file)
    }
  )

  # Return button to download the example mapping
  # References
  # https://shiny.posit.co/r/reference/shiny/0.11/downloadhandler.html
  output$downloadExampleMapping <- downloadHandler(
    filename = function() {
      paste('SARSCoV2Mapping', Sys.Date(), '.csv', sep='')
    },
    content = function(file) {
      write.csv(SARSCoV2Mapping, file, row.names=FALSE)
    }
  )



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
      # References
      # https://shiny.posit.co/r/reference/shiny/0.11/downloadhandler.html
      output$downloadPairs <- downloadHandler(
        filename = function() {
          paste('closest_and_farthest_pairs_', Sys.Date(), '.csv', sep='')
        },
        content = function(file) {
          write.csv(combinedPairsTable, file)
        }
      )

      # Render the closest and farthest pairs table.
      # References https://shiny.posit.co/r/articles/build/datatables/
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
        # References
        # https://shiny.posit.co/r/reference/shiny/0.11/downloadhandler.html
        output$downloadMapping <- downloadHandler(
          filename = function() {
            paste('mapping_distances_and_ranks_', Sys.Date(), '.csv', sep='')
          },
          content = function(file) {
            write.csv(combinedMappingTable, file)
          }
        )

        # Render the distance and rank table for the mapping.
        # References https://shiny.posit.co/r/articles/build/datatables/
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
            # Fluid row allows for formatting of items within a panel
            # References
            # https://shiny.posit.co/r/reference/shiny/1.8.0/fluidpage.html
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

# [END]
