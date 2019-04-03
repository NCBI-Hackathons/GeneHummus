#' Get architecture identifiers for the conserved domains
#'
#' Parses SPARCLE database (NCBI) and extract electronic identifiers for 
#' each conserved domain.
#'
#' @usage
#' archids_warning(gene_family)
#' 
#' @param 
#' gene_family A string with conserved domain(s).
#' 
#' @author Jose V. Die
 
archids_warning <- 
function(gene_family) {
  cd <- vector(mode = "character")
  
  for(i in seq_along(gene_family)) {
    cd <- c(cd, getSparcleArchs(gene_family[i]) )
  }
  
  unique(cd)  
}

