#' Get RefSeq protein identifiers for the given taxonomic species
#'
#' Parse the RefSeq database using protein architecture identifiers and 
#' extract protein ids. for selected taxonomic species. Core function used 
#' by \code{\link{getProteins_from_tax_ids}}.
#'
#' @importFrom httr set_config config
#' 
#' @usage
#' proteins_warning(arch_ids, taxonIds)
#'
#' @param arch_ids A string with the electronic links for the SPARCLE.
#' @param taxonIds A vector string with taxonomy ids. 
#'
#' @author Jose V. Die

proteins_warning <- 
function(arch_ids, taxonIds) {
  
  set_config(config(http_version = 0))
  
  my_values = c()
  for(n in seq(arch_ids)) {
    
    target <- getProtlinks(arch_ids[n])
    if(!is.null(target)) {
      
      if(length(target) < 301) {
        my_values <- c(my_values, extract_proteins(target, taxonIds))
        
      } else {
        protIds_subset <-  subsetIds(target,  sizeIds)
        
        for(i in seq_along(protIds_subset)) {
          my_targets = protIds_subset[[i]]
          my_values = c(my_values, extract_proteins(my_targets, taxonIds ))
          
        }
      }
    }
    
  }
  my_values = unique(my_values)
  my_values  
}
