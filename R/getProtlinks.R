#' Get the protein identifiers for a given architecture
#'
#' Parse the RefSeq database and extract all the protein identifiers that
#' have a given architecture.
#'
#' @importFrom rentrez entrez_link
#' 
#' @usage
#' getProtlinks(archs_ids)
#'
#' @param archs_ids A string with the architecture identifiers
#'   (SPARCLE database, NCBI)
#'
#' @author Jose V. Die


getProtlinks <-
function(archs_ids) {
  spar_to_prot = entrez_link(dbfrom = "sparcle", db = "protein",
                             id = archs_ids)
  prot_links = spar_to_prot$links$sparcle_protein
  prot_links
}
