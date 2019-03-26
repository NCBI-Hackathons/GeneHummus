#' Get the RefSeq protein identifiers for the given taxonomic species
#'
#' Parse the RefSeq database using protein architecture identifiers (SPARCLE dabatse)
#' and extract the protein ids. for the selected taxonomic species.
#'
#' @importFrom httr set_config
#' @importFrom curl has_internet
#' 
#' @usage
#' getProteins_from_tax_ids(arch_ids, taxonIds)
#'
#' @param arch_ids A string with the electronic links for the SPARCLE.
#' @param taxonIds A vector string with taxonomy ids; Legume species available
#'   in RefSeq, by default.
#'
#' @return
#' RefSeq protein identifiers for selected species.
#'
#' @examples 
#' filtered_archids <- c("12034188", "12034184")
#' getProteins_from_tax_ids(filtered_archids, legumesIds)
#' 
#' @author Jose V. Die
#'
#' @export


getProteins_from_tax_ids <-
function(arch_ids, taxonIds){
  
  if(!curl::has_internet()) {
    message("This function requires Internet connection.")
  } else {
    httr::set_config(httr::config(http_version = 0))
    my_values = c()
    
    for(n in seq(arch_ids)) {
      target <- getProtlinks(arch_ids[n])
      
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
    
    my_values = unique(my_values)
    my_values
  }
  }
