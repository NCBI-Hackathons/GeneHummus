#' Get acessions and organism for each protein identifier
#'
#' Core function used by \code{\link{getAccessions}}.
#'
#' @importFrom rentrez entrez_post entrez_summary extract_from_esummary
#' @importFrom dplyr %>% mutate select
#' 
#' @usage
#' accessions_warning(protein_ids)
#'
#' @param protein_ids A string vector containing protein identifiers.
#'
#' @author Jose V. Die


accessions_warning <-  
function(protein_ids) {
  vals = c()
  
  if(length(protein_ids) < 300 ) {
    upload <- entrez_post(db="protein", id=protein_ids) #create a web_history object
    prot_summ = entrez_summary(db="protein", web_history=upload)
    vals = as.character((extract_from_esummary(prot_summ, c("caption","title")))) 
    
  } else {
    protein_ids = subsetIds(protein_ids, sizeIds)
    for(i in seq(length(protein_ids))) {
      upload <- entrez_post(db="protein", id=protein_ids[[i]]) #create a web_history object
      prot_summ = entrez_summary(db="protein", web_history=upload)
      vals = c(vals, as.character((extract_from_esummary(prot_summ, c("caption","title")))))
    }
  }
  
  vals_df = data.frame(matrix(unlist(vals), 
                              nrow = length(vals)/2, byrow = T), #/2 bc 2 cols
                       row.names = colnames(vals),
                       stringsAsFactors = F) 
  
  colnames(vals_df) = c("accession", "desc")
  vals_df
  
  sci_name  = sapply(vals_df$desc, function(x) get_spp(x), USE.NAMES = FALSE)
  
  vals_df %>%
    mutate(organism = sci_name) %>% 
    select(accession, organism) -> my_data
  
  my_data 
}