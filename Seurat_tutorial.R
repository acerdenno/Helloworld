library(dplyr)
library(Seurat)
library(patchwork)
#llamr librerías con paquetes
pbmc.data <- Read10X(data.dir = "C:/Users/carlo/Downloads/pbmc3k_filtered_gene_bc_matrices/filtered_gene_bc_matrices/hg19")
#crear .data a partir de raw data de cellranger
#atento a la dirección de las barras en los comandos
# Initialize the Seurat object with the raw (non-normalized data).
pbmc <- CreateSeuratObject(counts = pbmc.data, project = "pbmc3k", min.cells = 3, min.features = 200)
pbmc
# Lets examine a few genes in the first thirty cells
pbmc.data[c("CD3D", "TCL1A", "MS4A1"), 1:30]
dense.size <- object.size(as.matrix(pbmc.data))
dense.size
sparse.size <- object.size(pbmc.data)
sparse.size
> # The [[ operator can add columns to object metadata. This is a great place to stash QC stats
  > pbmc[["percent.mt"]] <- PercentageFeatureSet(pbmc, pattern = "^MT-")
> # Show QC metrics for the first 5 cells
  > head(pbmc@meta.data, 5)
> # Visualize QC metrics as a violin plot
VlnPlot(pbmc, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)
Warning: Default search for "data" layer in "RNA" assay yielded no results; utilizing "counts" layer instead.
pbmc <- subset(pbmc, subset = nFeature_RNA > 200 & nFeature_RNA < 2500 & percent.mt < 5)

pbmc <- FindVariableFeatures(pbmc, selection.method = "vst", nfeatures = 2000)

# Identify the 10 most highly variable genes
top10 <- head(VariableFeatures(pbmc), 10)

# plot variable features with and without labels
plot1 <- VariableFeaturePlot(pbmc)
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
plot1 + plot2