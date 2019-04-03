#' Get the RefSeq protein identifiers for the given taxonomic species
#'
#' Parse the RefSeq database using protein architecture identifiers (SPARCLE dabatse)
#' and extract the protein ids. for the selected taxonomic species.
#'
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
#' filtered_archids <- c("12034184")
#' medicago <- c(3880)
#' getProteins_from_tax_ids(filtered_archids, medicago)
#' 
#' @author Jose V. Die
#'
#' @export


getProteins_from_tax_ids <-
function(arch_ids, taxonIds = legumesIds){

  if(!has_internet()) {
    message("This function requires Internet connection.")
  } else {
    tryCatch(
      expr    = {proteins_warning(arch_ids, taxonIds)}, 
      error   = function(e) {message("NCBI servers are busy. Please try again a bit later.")},
      warning = function(w) {message("NCBI servers are busy. Please try again a bit later.")}
    )
  }
}

utils::globalVariables("legumesIds")