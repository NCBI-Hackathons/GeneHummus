#' Extract the accession ids (XP accession) for a given organism
#' 
#' Filter a dataframe of protein ids and return the accessions for a given 
#' species or organism. 
#'  
#' @importFrom dplyr %>% filter pull
#' 
#' @usage accessions_from_spp(my_accessions, spp)
#' 
#' @param my_accessions A data frame with accession protein ids and organisms 
#' @param spp A string with the scientific name of the species or organism. 
#'   
#' @seealso \code{\link{getAccessions}} to create the data frame with accession 
#'   id and organism for each protein identifier.
#' 
#' @return A string vector with protein accession (XP accession, RefSeq database)
#'   
#' @examples
#' my_prots = data.frame(accession = c("XP_014620925", "XP_003546066", 
#'    "XP_025640041", "XP_019453956", "XP_006584791", "XP_020212415", 
#'    "XP_017436622", "XP_004503803", "XP_019463844"),
#'    organism =  c("Glycine max", "Glycine max", "Arachis hypogaea",
#'    "Lupinus angustifolius", "Glycine max", "Cajanus cajan", 
#'    "Vigna angularis", "Cicer arietinum", "Lupinus angustifolius"))
#'    
#' accessions_from_spp(my_prots, "Glycine max")
#'  
#' @author Jose V. Die 
#'  
#' @export


accessions_from_spp <- function(my_accessions, spp){
  
  my_accessions %>%
  filter(organism == spp) -> accs 
  
  accs[[1]]
  
}
