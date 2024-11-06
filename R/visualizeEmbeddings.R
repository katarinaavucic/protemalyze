#' Plot an Interactive UMAP From an Embedding Matrix
#'
#' A function that creates an interactive plot of the UMAP created from an
#'     embedding matrix.
#'
#' @param embeddingMatrix A data frame containing an embedding matrix with
#'     identifiers in the index and columns representing embedding dimensions.
#'
#' @return Produces an interactive plot of the UMAP created from an
#'     embedding matrix.
#'
#' @examples
#' \dontrun{
#' # Plot an interactive UMAP
#' embeddingMatrix <- eColiEmbeddingMatrix
#' visualizeEmbeddingUMAP(embeddingMatrix)
#' }
#'
#' @import dplyr
#' @import umap
#' @importFrom plotly plot_ly layout
#' @export
visualizeEmbeddingUMAP <- function(embeddingMatrix){

  # Generate umap from embedding matrix.
  umap <- umap::umap(embeddingMatrix, n_components = 2)
  layout <- data.frame(umap[["layout"]])

  # Create interactive plot.
  plot <- plotly::plot_ly(data = layout, x = ~X1, y = ~X2, type = "scatter",
                          mode = "markers", text = rownames(layout),
                          hoverinfo = "text",
                          marker = list(size = 10, opacity = 0.8,
                                        color = '#b78ec1',
                                        line = list(color = '#884499',
                                                    width = 1)
                                        )) %>%
          plotly::layout(title = "UMAP of Embedding Matrix",
                         plot_bgcolor = "lightgray",
                                    xaxis = list(title = "UMAP1"),
                                    yaxis = list(title = "UMAP2"))
  return(plot)
}

#' Plot the Distribution of Embedding Distances in a Mapping
#'
#' A function that plots the distribution of embedding distances from a distance
#'     matrix according to a mapping.
#'
#' @param distanceMatrix A data frame representing the distance matrix from
#'     an embedding matrix. Each value in the distance matrix is the distance
#'     calculated between the row and column embeddings. The distance matrix
#'     should contain protein identifies in the row and columns indices, with
#'     the diagonal all zeroes.
#'
#' @param mapping A data frame with two columns of protein identifiers matching
#'     the identifiers used for the embedding matrix.
#'
#' @return Produces a histogram of the distribution of embedding distances in a
#'     mapping.
#'
#' @examples
#' \dontrun{
#' # Generate distance matrix with default setings
#' eColiDistMatrix <- generateDistanceMatrix(eColiEmbeddingMatrix)
#'
#' # Visualize distance distribution by mapping
#' mapping <- eColiParalogMapping
#' visualizeDistanceDistribution(eColiDistMatrix, mapping)
#' }
#'
#' @import ggplot2
#' @importFrom stats median
#' @export
visualizeDistanceDistribution <- function(distanceMatrix, mapping){

  # Retrieve distances for the mapping.
  mappingDistances <- getDistancesByMapping(distanceMatrix, mapping)

  # Calculate binwidth based on data range put in 25 bins.
  dataRange <- max(mappingDistances$Distance) - min(mappingDistances$Distance)
  binwidth <- dataRange / 25

  plot <- ggplot2::ggplot(mappingDistances, ggplot2::aes(x = Distance)) +
    # Add median line.
    ggplot2::geom_histogram(binwidth = binwidth, fill = "#b78ec1",
                            color = "lightgray", alpha = 0.9, boundary = 0) +
    ggplot2::geom_vline(ggplot2::aes(xintercept = stats::median(Distance)),
                        color = "darkred", linetype = "dashed",
                        linewidth = 0.5) +
    # Add labels.
    ggplot2::labs(
      title = "Distribution of Embedding Distances in Mapping",
      subtitle = paste("Median Distance:",
                       stats::median(mappingDistances$Distance)),
      x = "Distance",
      y = "Number of Proteins"
    ) +
    # Add formatting.
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = 16, face = "bold"),
      plot.subtitle = ggplot2::element_text(size = 12, color = "dimgray"),
      axis.title = ggplot2::element_text(size = 12),
      axis.text = ggplot2::element_text(size = 10),
      panel.grid.minor = ggplot2::element_blank()
    )

  return(plot)
}


#' Plot the Distribution of Embedding Ranks in a Mapping
#'
#' A function that plots the distribution of embedding ranks from a rank matrix
#'     according to a mapping.
#'
#' @param rankMatrix A data frame representing the rank matrix calculated from
#'     an embedding matrix. Each value in the rank matrix is the rank of the
#'     distance of the column protein compared to all other distances computed
#'     with the row protein. These are not reciprocal values, and the diagonal
#'     (where the row and column protein are the same) is always rank 0. The
#'     rank matrix contains protein identifies in the row and columns indices.
#'
#' @param mapping A data frame with two columns of protein identifiers matching
#'     the identifiers used for the embedding matrix.
#'
#' @return Produces a histogram of the distribution of embedding ranks in a
#'     mapping.
#'
#' @examples
#' \dontrun{
#' # Generate distance matrix with default setings
#' eColiDistMatrix <- generateDistanceMatrix(eColiEmbeddingMatrix)
#'
#' # Generate rank matrix from distance matrix
#' eColiRankMatrix <- generateRankMatrix(eColiDistMatrix)
#'
#' # Visualize rank distribution by mapping
#' mapping <- eColiParalogMapping
#' visualizeRankDistribution(eColiRankMatrix, mapping)
#' }
#'
#' @import ggplot2
#' @importFrom stats median
#' @export
visualizeRankDistribution <- function(rankMatrix, mapping){

  # Retrieve distances for the mapping.
  mappingRanks <- getRanksByMapping(rankMatrix, mapping)

  # Calculate binwidth based on data range put in 25 bins.
  dataRange <- max(mappingRanks$Rank) - min(mappingRanks$Rank)
  binwidth <- dataRange / 25

  plot <- ggplot2::ggplot(mappingRanks, ggplot2::aes(x = Rank)) +
    # Add median line.
    ggplot2::geom_histogram(binwidth = binwidth, fill = "#b78ec1",
                            color = "lightgray", alpha = 0.9, boundary = 0) +
    ggplot2::geom_vline(ggplot2::aes(xintercept = stats::median(Rank)),
                        color = "darkred", linetype = "dashed",
                        linewidth = 0.5) +
    # Add labels.
    ggplot2::labs(
      title = "Distribution of Embedding Ranks in Mapping",
      subtitle = paste("Median Rank:", stats::median(mappingRanks$Rank)),
      x = "Rank",
      y = "Number of Proteins"
    ) +
    # Add formatting.
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = 16, face = "bold"),
      plot.subtitle = ggplot2::element_text(size = 12, color = "dimgray"),
      axis.title = ggplot2::element_text(size = 12),
      axis.text = ggplot2::element_text(size = 10),
      panel.grid.minor = ggplot2::element_blank()
    )

  return(plot)
}

# [END]
