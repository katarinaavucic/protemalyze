# base template (include citation)
# https://shiny.posit.co/r/gallery/application-layout/tabsets/
# file upload (include citation)
# https://shiny.posit.co/r/gallery/widgets/file-upload/

library(shiny)

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

      # Input: File for Mapping (optional).
      fileInput("mappingFile", "Optional: Input Mapping File",
                accept = c(".csv", ".tsv")),

      # Action button to run the analysis
      actionButton(inputId = "runButton", label = "Run Analysis")

      # TODO: add inputs for specifying distance metrics, threads, etc.

    ),

    # Main panel for displaying outputs ----
    mainPanel(


      # Output: Tabset w/ UMAP, Pairs, Distributions, and Mapping ----
      tabsetPanel(type = "tabs",
                  tabPanel("Embedding UMAP", plotOutput("umapPlot")),
                  tabPanel("Closest and Farthest Pairs", plotOutput("pairsTable")),
                  tabPanel("Rank & Distance Distributions", plotOutput("distributionPlot")),
                  tabPanel("Mapping Ranks & Distances", tableOutput("mappingTable"))
      )
    )
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {

  # Reactive expression to load and process embedding matrix when file is uploaded
  embeddingMatrix <- reactive({
    req(input$embeddingFile)
    # source: https://mastering-shiny.org/action-transfer.html
    fileType <- tools::file_ext(input$embeddingFile$name)
    embeddingMatrix <- loadEmbeddings(input$embeddingFile$datapath, fileType)
    embeddingMatrix <- processData(embeddingMatrix)
    return(embeddingMatrix)
  })

  # Reactive expression to process mapping file if uploaded
  paralogMapping <- reactive({
    req(input$mappingFile)
    mapping <- read.csv(input$mappingFile$datapath)
    return(mapping)
  })

  # Run analysis when action button is clicked
  observeEvent(input$runButton, {

    # Generate UMAP plot using the processed embedding matrix.
    output$umapPlot <- renderPlot({
      # Must do this to use the result of the reactive expression.
      embeddingMatrixData <- embeddingMatrix()
      plot <- visualizeEmbeddingUMAP(embeddingMatrixData)
      return(plot)
    })

    # Generate closest pairs and farthest pairs
    output$pairsTable <- renderPlot({
      # Must do this to use the result of the reactive expression.
      embeddingMatrixData <- embeddingMatrix()
      eColiDistMatrix <- generateDistanceMatrix(embeddingMatrixData)
      eColiRankMatrix <- generateRankMatrix(eColiDistMatrix)
      closestPairs <- getClosestPairs(eColiRankMatrix)
      farthestPairs <- getFarthestPairs(eColiRankMatrix)

      # TODO: somehow return these tables.
    })

    # Visualize rank and distance distributions
    output$distributionPlot <- renderPlot({
      # Must do this to use the result of the reactive expression.
      embeddingMatrixData <- embeddingMatrix()
      eColiDistMatrix <- generateDistanceMatrix(embeddingMatrixData)
      eColiRankMatrix <- generateRankMatrix(eColiDistMatrix)

      distPlot <- visualizeDistanceDistribution(eColiDistMatrix)
      rankPlot <- visualizeRankDistribution(eColiRankMatrix)

      # TODO: somehow return these plots.
    })

    # Show ranks and distances if mapping is provided
    output$mappingTable <- renderTable({
      mapping <- paralogMapping()
      if (length(eColiMapping) > 0) {
        eColiDistMatrix <- generateDistanceMatrix(embeddingMatrix())
        eColiRankMatrix <- generateRankMatrix(eColiDistMatrix)
        paralogDistances <- getDistancesByMapping(eColiDistMatrix, mapping)
        paralogRanks <- getRanksByMapping(eColiRankMatrix, mapping)
        distPlot <- visualizeDistanceDistribution(eColiDistMatrix)
        rankPlot <- visualizeRankDistribution(eColiRankMatrix)

        # TODO: somehow return these tables and plots.
      }
    })
  })
}

# Create Shiny app ----
shinyApp(ui, server)
