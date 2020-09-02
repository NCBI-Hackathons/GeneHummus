#' Filter protein architectures based on conserved domains
#'
#' Parse the architecture identifiers and extract those which label contains, at
#' least, the conserved domains or the family name  
#'
#' @usage
#' filterarchids_warning(archs_ids, filter, family_name)
#'
#' @param archs_ids A string with the architecture identifiers.
#' @param filter A string with the domains as filter. 
#' @param family_name A string with the family name as filter. 
#'
#' @importFrom rentrez entrez_summary
#' @importFrom stringr str_count
#' 
#' @author Jose V. Die


filterarchids_warning <- 
  function(archs_ids, filter, family_name) {
    my_labelsIds <- vector(mode = "character")
    
    for(id in archs_ids) {
      sid = entrez_summary(db = "sparcle", id = id)
      
      # some sparcle ids do not give esummary. ex: "12217856"
      # only if esummary:
      if(length(sid) > 2) {
        
        # check if label contains required domains OR family name
        if(length(filter) > 1) {
          if(sum(str_count(sid$displabel, filter)) == length(filter) |
             sid$dispname == family_name) {
            my_labelsIds <- c(my_labelsIds, id)
          }
        } else {
          if(str_count(sid$displabel, filter) > 0  |
             sid$dispname == family_name) {
            my_labelsIds <- c(my_labelsIds, id)
          }
        }
      }
      
    }
    my_labelsIds
  } 

