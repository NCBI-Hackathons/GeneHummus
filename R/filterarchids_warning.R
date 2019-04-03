#' Filter protein architectures based on conserved domains
#'
#' Parse the architecture identifiers and extract those that contain, at
#' least, the conserved domaind selected as filter.
#'
#' @usage
#' filterarchids_warning(archs_ids, filter)
#'
#' @param archs_ids A string with the architecture identifiers.
#' @param filter A string with the domains as filter. 
#'
#' @importFrom rentrez entrez_summary
#' @importFrom stringr str_count
#' 
#' @author Jose V. Die

filterarchids_warning <- 
function(archs_ids, filter) {
  my_labelsIds <- vector(mode = "character")
  
  for(id in archs_ids) {
    sid = entrez_summary(db = "sparcle", id = id)
    
    # some sparcle ids do not give esummary. ex: "12217856"
    # only if esummary:
    if(length(sid) > 2) {
      
      # check label contains required CDs
      if(sum(str_count(sid$displabel, filter)) == length(filter) ) {
        my_labelsIds <- c(my_labelsIds, id)
      }
      
    }
  }
  my_labelsIds  
}

