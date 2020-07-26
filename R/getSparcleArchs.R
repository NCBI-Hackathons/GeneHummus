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
#' @author Jose V. Die


getSparcleArchs <-
function(CD){

    cdd_sparcle = c()
    id = entrez_search(db = "cdd", term = paste0(CD,"[ALL]"))
    for(i in seq_along(id$ids)) {
      cd = entrez_summary(db = "cdd", id = id$ids[i])
      sparcle = entrez_link(dbfrom = "cdd", db = "sparcle", id = cd$uid)
      cdd_sparcle = c(cdd_sparcle, sparcle$links$cdd_sparcle)
    }
    
    cdd_sparcle

  }
