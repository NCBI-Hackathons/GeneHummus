#' Get the potential architecture identifiers for the conserved domains
#'
#' Parses the SPARCLE database (NCBI) and extract the electronic identifiers
#' for each conserved domain.
#'
#' @importFrom curl has_internet
#' 
#' @usage
#' getArch_ids(gene_family)
#'
#' @param
#' gene_family A string with the conserved domain(s) defining the gene
#'   family. The domains have to be shown in the same order appearing in
#'   the sequences.
#'
#' @return
#' the architectures identifiers for each of the conserved domains.
#'
#' @examples 
#' arf <- c("pfam06507")
#' getArch_ids(arf)
#' 
#' @author Jose V. Die
#'
#' @export


getArch_ids <-
function(gene_family) {

  if(!has_internet()) {
    message("This function requires Internet connection.")
  } else {
    
    tryCatch(
      expr    = {archids_warning(gene_family)}, 
      error   = function(e) {message("NCBI servers are busy. Please try again a bit later.")},
      warning = function(w) {message("NCBI servers are busy. Please try again a bit later.")}
    )
  }
  }
