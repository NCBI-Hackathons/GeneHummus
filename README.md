---
title: "README"
author: "Jose V Die"
date: "28/2/2019"
output: html_document
---

# geneHummus

An Automated Pipeline to Study **Plant Gene Families based on Protein Domain Organization** using Auxin Response Factors in **chickpea** and other Legumes as an Example. The pipeline is convenient if you are interested in plant gene families characterization, or you'd like to perform some downstream analysis such as phylogenetic construction or gene expression profiling, to name a few examples. 


## Accessing the package
A stable version of this package is available on CRAN and can be installed directly from there:  

    install.packages("geneHummus")
    
The lastest development version of the package can also be loaded directly from GitHub using the devtools package:
  
    library(devtools)
    install_github("NCBI-Hackathons/GeneHummus")
    library(GeneHummus)
    

## Development version
This current version contains important changes related to the CRAN version: 
Some modifications in the SPARCLE database changed the label of some SPARCLE architectures. In `geneHummus`the filtering step has been modified accordingly. Now that step should include : required conserved domains + gene family name.   
See the [vignette](vignettes/genHummus.md) for details.
 

## Publication
Die JV, Elmassry MM, Leblanc KH, Awe OI, Dillman A, Busby B (2019) GeneHummus: A pipeline to define gene families and their expression in legumes and beyond, [BMC Genomcis 20 : 591](https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-019-5952-2).  

<br>
