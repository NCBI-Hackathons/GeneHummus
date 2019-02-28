#' Get the electronic architecture for a conserved domain
#'
#' Parses the SPARCLE database (NCBI) and extract the electronic links for
#' a given conserved domain.
#'
#' @usage
#' getSparcleArchs(CD)
#'
#' @param
#' CD A string with the conserved domain(s)
#'
#' @importFrom rentrez entrez_search entrez_summary entrez_link
#'
#' @examples \dontrun{
#' CD = "pfam02362"
#' getSparcleArchs(CD) }
#'
#' @author Jose V. Die


getSparcleArchs <-
function(CD){

  id = entrez_search(db = "cdd", term = paste0(CD,"[ALL]"))
  cd = entrez_summary(db = "cdd", id = id$ids)
  sparcle = entrez_link(dbfrom = "cdd", db = "sparcle", id = cd$uid)
  sparcle$links$cdd_sparcle

  }
