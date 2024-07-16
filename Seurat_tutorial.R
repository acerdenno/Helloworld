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