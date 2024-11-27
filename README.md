
<!-- README.md is generated from README.Rmd. Please edit that file -->

# protemalyze

<!-- badges: start -->
<!-- badges: end -->

## Description

*protemalyze* is an R package designed to analyze protein embeddings
derived from protein Language Models (pLMs). Protein embeddings are
numerical representations of protein sequences, where each protein is
mapped to a fixed-length vector in a high-dimensional space (Chandra et
al., 2023). pLMs have been shown to capture essential information about
protein sequences, and predictive models trained with protein embeddings
often perform comparably to other encoding methods, despite having fewer
dimensions (Yang et al., 2018). These embeddings are particularly useful
for downstream tasks, such as identifying structurally or functionally
similar proteins (Elnaggar et al., 2021). Despite their potential, these
tools remain underutilized in the scientific community, primarily due to
a knowledge barrier. protemalyze aims to lower this barrier, providing a
more accessible entry point for researchers to explore data from pLMs
without having to engage with the technical details of the underlying
methods.

The *protemalyze* package was developed using R version 4.4.1
(2024-06-14), Platform: aarch64-apple-darwin20 (64-bit) and Running
under: macOS Sonoma 14.5.

------------------------------------------------------------------------

## Installation

You can install the development version of protemalyze like so:

``` r
install.packages("devtools")
library("devtools")
devtools::install_github("katarinaavucic/protemalyze", build_vignettes = TRUE)
library("protemalyze")
```

------------------------------------------------------------------------

## Overview

To list all the functions available in the package:

``` r
ls("package:protemalyze")
```

To list the datasets in the package:

``` r
data(package = "protemalyze") 
```

To access tutorials for the package:

``` r
browseVignettes("protemalyze")
```

`protemalyze` contains 12 functions.

1.  ***loadEmbeddings*** for loading an embedding matrix from a “csv”,
    tsv”, or “h5” file.

2.  ***processData*** for removing NULL and duplicate values from an
    embedding matrix.

3.  ***generateDistanceMatrix*** for computing a distance matrix from an
    embedding matrix.

4.  ***generateRankMatrix*** for computing a rank matrix from an
    embedding matrix.

5.  ***getClosestPair*** for retrieving the closest pair for each
    protein in a ranked matrix.

6.  ***getFarthestPair*** for retrieving the farthest pair for each
    protein in a ranked matrix.

7.  ***getDistanceByMapping*** for retrieving the embedding distances
    from a distance matrix for protein pairs in a mapping.

8.  ***getRankByMapping*** for retrieving the embedding ranks from a
    rank matrix for protein pairs in a mapping.

9.  ***visualizeEmbeddingUMAP*** for visualizing the embedding matrix
    with an interactive plot of the UMAP created from the embedding
    matrix.

10. ***visualizeDistanceDistribution*** for visualizing the distribution
    of embedding distances from a distance matrix according to a
    mapping.

11. ***visualizeRankDistribution*** for visualizing the distribution of
    embedding ranks from a rank matrix according to a mapping.

12. **runProtemalyze** for launching the Shiny app which provides an
    interactive interface for visualizing and analyzing protein
    embeddings.

The package also contains an embedding matrix from Escherichia coli,
called **eColiEmbeddingMatrix** and a mapping of the paralogs in
Escherichia coli, called **eColiParalogMapping**. Refer to package
vignettes for more details. An overview of the package is illustrated
below.

![](./inst/extdata/protemalyzeOverview.jpg)

------------------------------------------------------------------------

## Contributions

The creator and maintainer of this package is Katarina Vucic, who wrote
all of the functions.

1.  `loadEmbeddings`

**Author:** Katarina Vucic

The `loadEmbeddings` function is responsible for loading an embedding
matrix from a file, which can be in “csv”, “tsv”, or “h5” format. It
uses different file-importing techniques to read the data and store it
in a matrix. The function makes use of the `readr`, `rhdf5`, and `dplyr`
R packages. The `readr` package is used for reading CSV and TSV files.
The`rhdf5` is used for loading data stored in HDF5 format, especially
for larger datasets. The `dplyr` package is used for organizing the
imported data into a readable format. The `rhdf5`
[vignette](https://www.bioconductor.org/packages/devel/bioc/vignettes/rhdf5/inst/doc/rhdf5.html#high-level-r-hdf5-functions)
was referenced to read the h5 file.

2.  `processData`

**Author:** Katarina Vucic

The `processData` function is responsible for cleaning the embedding
matrix by removing NULL values and duplicates. It uses standard data
manipulation techniques to ensure the matrix is free from missing values
or duplicate proteins. The function makes use of the `dplyr` and
`tibble` R packages. The `dplyr` package is used for data manipulation
tasks such as removing NULL and duplicate values. The `tibble` package
is used for organizing the cleaned data into a tibble format.

3.  `generateDistanceMatrix`

**Author:** Katarina Vucic

The `generateDistanceMatrix` function computes a distance matrix from
the provided embedding matrix. It calculates pairwise distances between
protein embeddings, which can be used for further analysis. The function
makes use of the `parallelDist` R packages. The `parallelDist` package
is used for efficiently calculating the distance matrix using parallel
processing, which helps handle large datasets. The `parallelDist`
package performs the underlying pairwise distance computation.

4.  `generateRankMatrix`

**Author:** Katarina Vucic

The `generateRankMatrix` function computes a rank matrix from the
embedding matrix. It ranks the distances between proteins, providing a
relative measure of how close or far proteins are in the embedding
space. The function makes use of the `matrixStats` R packages. The
`matrixStats` package is used for efficiently calculating ranks in large
datasets. The `matrixStats` package performs the underlying rank
computation.

5.  `getClosestPair`

**Author:** Katarina Vucic

The `getClosestPair` function retrieves the closest protein pair for
each protein in the ranked matrix. It identifies the most similar
protein for each protein based on the calculated ranks. The function
makes use of the `base` R package. The `which()` function is used to
determine the columns with a rank of 1.

6.  `getFarthestPair`

**Author:** Katarina Vucic

The `getFarthestPair` function retrieves the farthest protein pair for
each protein in the ranked matrix. It identifies the most dissimilar
protein for each protein based on the calculated ranks. The function
makes use of the `base` R package. The `which()` function is used to
determine the columns with a rank equal to the number of rows.

7.  `getDistanceByMapping`

**Author:** Katarina Vucic

The `getDistanceByMapping` function retrieves the embedding distances
from the distance matrix for protein pairs in a provided mapping. It
returns the pairwise distances for proteins based on a predefined
mapping, such as paralog mappings. The function makes use of the `base`
R package. The `match()` function is used to find the indices of protein
pairs in the distance matrix. The `cbind()` function is used to index
the specific positions in the distance matrix for the protein pairs.

8.  `getRankByMapping`

**Author:** Katarina Vucic

The `getRankByMapping` function retrieves the embedding ranks from the
rank matrix for protein pairs in a provided mapping. It returns the
pairwise ranks for proteins based on a predefined mapping, such as
paralog mappings. The function makes use of the `base` R package. The
`match()` function is used to find the indices of protein pairs in the
distance matrix. The `cbind()` function is used to index the specific
positions in the distance matrix for the protein pairs.

9.  `visualizeEmbeddingUMAP`

**Author:** Katarina Vucic

The `visualizeEmbeddingUMAP` function visualizes the embedding matrix by
reducing the data to a lower-dimensional space and creating an
interactive UMAP plot. It allows the user to explore the positions of
proteins in the embedding space. The function makes use of the `umap`
and `plotly` R packages. The `umap` package is used for dimensionality
reduction, specifically for creating the UMAP projection of the
embedding matrix. The `plotly` package is used for creating interactive
plots of the UMAP results. The `plotly` [scatter and line plots in
R](https://plotly.com/r/line-and-scatter/) and [marker
styling](https://plotly.com/r/marker-style/) documentation were
referenced during the creation of the function.

10. `visualizeDistanceDistribution`

**Author:** Katarina Vucic

The `visualizeDistanceDistribution` function visualizes the distribution
of embedding distances from the distance matrix according to a given
mapping. It helps in analyzing how the distances between proteins are
distributed. The function makes use of the `ggplot2` R packages. The
`ggplot2` is used for creating visualizations of the distance
distribution. The `ggplot2` [geom_histogram
examples](https://ggplot2.tidyverse.org/reference/geom_histogram.html)
and [general documentation](https://ggplot2.tidyverse.org/reference/)
was referenced throughoout the creation of this function. The Geeks for
Geeks [adding the mean line
example](https://www.geeksforgeeks.org/how-to-display-mean-in-a-histogram-using-ggplot2-in-r/)
was referenced to add the median line.

11. `visualizeRankDistribution`

**Author:** Katarina Vucic

The `visualizeRankDistribution` function visualizes the distribution of
embedding ranks from the rank matrix according to a given mapping. It
helps in analyzing how the ranks of proteins are distributed. The
function makes use of the `ggplot2` R packages. The `ggplot2` is used
for creating visualizations of the distance distribution. The `ggplot2`
[geom_histogram
examples](https://ggplot2.tidyverse.org/reference/geom_histogram.html)
and [general documentation](https://ggplot2.tidyverse.org/reference/)
was referenced throughoout the creation of this function. The Geeks for
Geeks [adding the mean line
example](https://www.geeksforgeeks.org/how-to-display-mean-in-a-histogram-using-ggplot2-in-r/)
was referenced to add the median line.

12. `runProtemalyze`

**Author:** Katarina Vucic

The `runProtemalyze` function is responsible for launching the Shiny app
for the `protemalyze` package. It provides an interactive interface for
visualizing and analyzing protein embeddings. The function makes use of
the `shiny` R package. The `shiny` package is used for creating the web
application framework and handling the app’s user interface and server
logic. The [Shiny Gallery on
Tabsets](https://shiny.posit.co/r/gallery/application-layout/tabsets/)
was used as a reference for designing the overall tabbed layout. The
`shiny`
[fluidPage](https://shiny.posit.co/r/reference/shiny/1.8.0/fluidpage.html)
function was referenced to create the layout structure. The `DT` package
is used for displaying interactive data tables within the app, as
described in the [Shiny Article on
DataTables](https://shiny.posit.co/r/articles/build/datatables/). The
`plotly` package is used for creating interactive plots, allowing users
to explore the data dynamically. The `fileInput` function for file
uploads was implemented using the [Shiny Gallery on File
Upload](https://shiny.posit.co/r/gallery/widgets/file-upload/), and file
download functionality is handled by the `downloadHandler`, as described
in the [Shiny Reference for
downloadHandler](https://shiny.posit.co/r/reference/shiny/0.11/downloadhandler.html).
Additionally, the function references techniques from [Mastering
Shiny](https://mastering-shiny.org/action-transfer.html) to manage file
uploads and set an upload limit of 50MB and retrieving the file type is
also based on information from [Mastering
Shiny](https://mastering-shiny.org/action-transfer.html).

Raw per-protein embeddings for E. coli, stored in
**eColiEmbeddingMatrix**, were generated by Uniprot (Batemen et al.,
2022). The one-to-many paralog mapping for E. coli, stored in
**eColiParalogMapping**, were generated using the Orthologous Matrix
(OMA) Browser (Altenhoff et al., 2018).

## References

- [Altenhoff, A. M., Glover, N. M., Train, C. M., Kaleb, K., Warwick
  Vesztrocy, A., Dylus, D., de Farias, T. M., Zile, K., Stevenson, C.,
  Long, J., Redestig, H., Gonnet, G. H., & Dessimoz, C. (2018). The OMA
  orthology database in 2018: retrieving evolutionary relationships
  among all domains of life through richer web and programmatic
  interfaces. Nucleic Acids Research, 46(D1),
  D477-D485.](https://pubmed.ncbi.nlm.nih.gov/29106550/)
- [Bateman, A., Martin, M.-J., Orchard, S., Magrane, M., Ahmad, S.,
  Alpi, E., Bowler-Barnett, E. H., Britto, R., Bye-A-Jee, H., Cukura,
  A., Denny, P., Dogan, T., Ebenezer, T., Fan, J., Garmiri, P., da Costa
  Gonzales, L. J., Hatton-Ellis, E., Hussein, A., Ignatchenko, A., &
  Insana, G. (2022). UniProt: the Universal Protein Knowledgebase
  in 2023. Nucleic Acids Research,
  51(D1).](https://doi.org/10.1093/nar/gkac1052)
- [Bengtsson H (2023). matrixStats: Functions that Apply to Rows and
  Columns of Matrices (and to Vectors). R package version
  1.0.0.](https://CRAN.R-project.org/package=matrixStats)
- [Chandra, A. A., Tünnermann, L., Löfstedt, T., & Grätz, R. (2023).
  Transformer-based deep learning for predicting protein properties in
  the life sciences. ELife, 12.](https://doi.org/10.7554/elife.82819)
- [Eckert A (2023). parallelDist: Parallel Distance Matrix Computation
  using Multiple Threads. R package version
  0.2.6.](https://CRAN.R-project.org/package=parallelDist)
- [Elnaggar, A., Heinzinger, M., Dallago, C., Rehawi, G., Wang, Y.,
  Jones, L., Gibbs, T., Feher, T., Angerer, C., Steinegger, M., Bhowmik,
  D., & Rost, B. (2021). ProtTrans: Towards Cracking the Language of
  Lifes Code Through Self-Supervised Deep Learning and High Performance
  Computing. IEEE Transactions on Pattern Analysis and Machine
  Intelligence, 44(10),
  1–1.](https://doi.org/10.1109/tpami.2021.3095381)
- [Fischer B, Smith M, Pau G (2023). rhdf5: R Interface to HDF5. R
  package version
  2.44.0.](https://bioconductor.org/packages/release/bioc/html/rhdf5.html)
- [Inc., P. T. (2015). plotly. Collaborative data science. Montreal, QC:
  Plotly Technologies Inc](https://plot.ly)
- [Konopka T (2023). umap: Uniform Manifold Approximation and
  Projection. R package version
  0.2.10.0](https://github.com/tkonopka/umap)
- [Müller K, Wickham H (2023). tibble: Simple Data Frames. R package
  version 3.2.1.](https://CRAN.R-project.org/package=tibble)
- [Sievert C (2023). plotly: Create Interactive Web Graphics via
  ‘plotly.js’. R package version
  4.10.2.](https://CRAN.R-project.org/package=plotly)
- [Wickham H, François R, Henry L, Müller K, Vaughan D (2023). dplyr: A
  Grammar of Data Manipulation. R package version
  1.1.3.](https://CRAN.R-project.org/package=dplyr)
- [Wickham H, Chang W, Henry L, Pedersen TL, Takahashi K, Wilke C, Woo
  K, Yutani H, Dunnington D (2023). ggplot2: Create Elegant Data
  Visualisations Using the Grammar of Graphics. R package version
  3.4.3.](https://CRAN.R-project.org/package=ggplot2)
- [Wickham H, Hester J, Bryan J (2023). readr: Read Rectangular Text
  Data. R package version
  2.1.4.](https://CRAN.R-project.org/package=readr)
- [Yang, K. K., Wu, Z., Bedbrook, C. N., & Arnold, F. H. (2018). Learned
  protein embeddings for machine learning. Bioinformatics, 34(15),
  2642–2648.](https://doi.org/10.1093/bioinformatics/bty178)

## Acknowledgements

This package was developed as part of an assessment for 2024 BCB410H:
Applied Bioinformatics course at the University of Toronto, Toronto,
CANADA. protemalyze welcomes issues, enhancement requests, and other
contributions. To submit an issue, use the GitHub issues.
