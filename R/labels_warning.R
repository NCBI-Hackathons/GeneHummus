#' Get description label for a protein architecture identifier
#'
#' Parses the architecture identifier and extract the corresponding labels.
#'
#' @usage
#' labels_warning(arch_ids)
#' 
#' @param arch_ids A string with the architecture electronic identifiers.
#' 
#' @importFrom rentrez entrez_summary
#' 
#' @author Jose V. Die

labels_warning <- function(arch_ids){
  
  for(id in arch_ids) {
    my_label_sum = entrez_summary(db = "sparcle", id = id)
    print(paste(id, my_label_sum$displabel))
  }
}

