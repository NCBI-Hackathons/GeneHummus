#' Get the acessions ids and the organism for each protein identifier
#' 
#' The \code{getAccessions} function parses the protein page for each identifier 
#' and extracts the accession id (usually referred as XP accession in the RefSeq
#' database) and the organism given by the scientific name. 
#'  
#' The \code{accessions_by_spp} and \code{accessions_from_spp} functions are 
#' convenient filters for further cleaning of \code{getAccessions} by giving 
#' the total number of XP accessions per species or extracting the XP 
#' accessions for a given species, respectively.  
#'  
#' @importFrom rentrez entrez_post entrez_summary extract_from_esummary
#' @importFrom dplyr %>% mutate select
#'  
#' @usage 
#' getAccessions(protein_ids)
#'  
#' @param protein_ids A string vector containing protein identifiers.
#'  
#' @seealso \code{\link{accessions_by_spp}} to summarize the total number of 
#'   accession proteins per species. 
#' @seealso \code{\link{accessions_from_spp}} to filter the accession ids for 
#'    a given species
#'  
#' @return A \code{data.frame} of protein ids including columns:
#' \itemize{
#' \item accession
#' \item organism  
#' }
#'  
#' @examples 
#' prot_ids <- c("593705262", "1379669790", "357520645",  "1150156484")
#' getAccessions(prot_ids)
#'  
#' @author Jose V. Die 
#'  
#' @export


getAccessions <- function(protein_ids) {
  
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

utils::globalVariables(c("accession", "organism"))
