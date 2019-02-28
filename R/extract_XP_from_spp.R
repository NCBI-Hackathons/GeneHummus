#' Get the XP accession ids for a selected Species
#'
#' Parse a string vector with the protein electronic ids and extract only
#' those for a selected species.
#'
#' The species name requires Genus or Genus species (NCBI nomenclature).
#' For example, for extracting only the chickpea sequences from a protein ids, use
#' : "Cicer" or "Cicer arietinum".
#'
#' @usage
#' extract_XP_from_spp(target, myspp)
#'
#' @param target A vector/list object with protein ids.
#' @param myspp A string with the species name to extract the XP ids.
#'
#' @importFrom rentrez entrez_post entrez_summary extract_from_esummary
#' @importFrom stringr str_detect
#'
#' @return
#' A string vector of XP ids for selected species.
#'
#' @examples
#' my_values <- c("571493944",  "828328898",  "1117487898", "1431691079",
#'  "828337470",  "502078116")
#' extract_XP_from_spp(my_values, "Cicer arietinum")
#'
#' @author Jose V. Die
#' @author Kimberly H. LeBlanc
#'
#' @export


extract_XP_from_spp <-
function(target, myspp) {
  # ''' target, vector/list object with protein ids
  # ''' spp, spp target to extract its XP ids.

  xp = c()
  prot_test = c()

  if(length(target) < 300   ) {

    upload <- entrez_post(db="protein", id=target) #create a web_history object
    prot_summ = entrez_summary(db="protein", web_history=upload)
    prot_test = as.character((extract_from_esummary(prot_summ, c("caption","title"))))

  } else {
    target = subsetIds(target, sizeIds)
    for(i in seq(length(target))) {
      upload <- entrez_post(db="protein", id=target[[i]]) #create a web_history object
      prot_summ = entrez_summary(db="protein", web_history=upload)
      prot_test = c(prot_test, as.character((extract_from_esummary(prot_summ, c("caption","title")))))

    } }

  # Build dataframe
  prot_test_df = data.frame(matrix(unlist(prot_test), nrow = length(prot_test)/2, byrow = T),
                            stringsAsFactors = F) # /2 bc we have 2 columns: caption,title

  # Extract ID based on selected species
  idx = which(str_detect(prot_test_df$X2, myspp))
  xp = prot_test_df[idx,1]

  xp


}
