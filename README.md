---
title: "README"
author: "Jose V Die"
date: "28/2/2019"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# geneHummus

An Automated Pipeline to Study **Plant Gene Families based on Protein Domain Organization** using Auxin Response Factors in **chickpea** and other Legumes as an Example. The pipeline is convenient if you are interested in plant gene families characterization, or you'd like to perform some downstream analysis such as phylogenetic construction or gene expression profiling, to name a few examples. 


## Accessing the package
A stable version of this package will be available on CRAN and could be installed directly from there:  

    install.packages("geneHummus")
    
The lastest development version of the package can also be loaded directly from GitHub using the devtools package:
  
    library(devtools)
    install_github("NCBI-Hackathons/GeneHummus")
    library(GeneHummus)
    
    
## Publication
Die JV, Elmassry MM, Leblanc KH, Awe OI, Dillman A, Busby B (2018) GeneHummus: A pipeline to define gene families and their expression in legumes and beyond, bioRxiv 436659; doi: https://doi.org/10.1101/436659

<br>
