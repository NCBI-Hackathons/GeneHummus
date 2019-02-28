#' Get the protein identifiers
#'
#' Extract the protein identifier for the given taxonomic species, which are
#'    hosted by the RefSeq database (NCBI).
#'
#' @param targets A string with the electronic links for the SPARCLE architecture.
#' @param taxonIds A string with the taxonomic species identifiers;
#'   legume species (by default).
#'
#' @importFrom rentrez entrez_summary extract_from_esummary
#' @importFrom dplyr %>% pull
#'
#' @details
#' First, get the protein ids from RefSeq database. Then, extract only the ids
#'   for the selected taxonomic species (by default, legume species).
#'
#' @author Jose V. Die

extract_proteins <-
function(targets, taxonIds) {

  # Initializes vector with the solution
  vals = c()

  ## A. Get taxids with protein ids in RefSeq
  #1 Get esummary for each protein id
  prot_summ = entrez_summary(db = "protein", id = targets)

  #2 Extract from esummary: 'sourcedb' and 'taxid'
  prot_db = extract_from_esummary(prot_summ, c("sourcedb", "taxid"))

  #3 Build df
  prot_db = data.frame(matrix(unlist(prot_db), nrow = length(prot_db)/2, byrow = T),
                       row.names = colnames(prot_db),
                       stringsAsFactors = F) #/2 bc 2 columns: sourcedb-taxid

  #4 Filter by db == RefSeq and make a new df
  #df2_refseq = prot_db %>% filter(X1 == "refseq")
  df2_refseq <- prot_db[prot_db$X1 == "refseq", ]

  #5 Pull taxids
  taxids_refseq = unique(as.numeric(df2_refseq %>% pull()))

  ## B. Filter taxids by selected taxonomic family
  # If taxonomic family :
  if(sum(taxids_refseq %in% taxonIds) != 0) {
    idx = which(taxids_refseq %in% taxonIds)
    taxids_refseq[idx]

    # Extract the rownames (=protein id) for selected taxids
    ## df2_refseq %>% filter(X2 %in% taxids_refseq[idx])
    ## base R
    vals = c(vals, rownames(df2_refseq[df2_refseq$X2 %in% taxids_refseq[idx],]))

  }

  vals

}
