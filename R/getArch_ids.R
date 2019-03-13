#' Get the potential architecture identifiers for the conserved domains
#'
#' Parses the SPARCLE database (NCBI) and extract the electronic identifiers
#' for each conserved domain.
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
#' all the architectures identifiers for each of the conserved domains.
#'
#' @examples \donttest{
#' arf <- c("pfam02362", "pfam06507", "pfam02309")
#' getArch_ids(arf)}
#'
#' @author Jose V. Die
#'
#' @export


getArch_ids <-
function(gene_family) {

  cd <- vector(mode = "character")

  for(i in seq_along(gene_family)) {
    cd <- c(cd, getSparcleArchs(gene_family[i]) )
  }

  unique(cd)
}
