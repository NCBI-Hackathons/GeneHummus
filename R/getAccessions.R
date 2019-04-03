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
#' @importFrom curl has_internet
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
#' \dontshow{
#' prot_ids <- c("1379669790")
#' getAccessions(prot_ids)}
#' 
#' \dontrun{
#' prot_ids <- c("593705262", "1379669790", "1150156484")
#' getAccessions(prot_ids)}
#'  
#' @author Jose V. Die 
#'  
#' @export


getAccessions <- 
function(protein_ids) {
  if(!has_internet()) {
    message("This function requires Internet connection.")
  } else {
    tryCatch(
      expr = {accessions_warning(protein_ids)}, 
      error = function(e) {message("NCBI servers are busy. Please try again a bit later.")},
      warning = function(w) {message("NCBI servers are busy. Please try again a bit later.")}
    )
  }
}
utils::globalVariables(c("accession", "organism"))
