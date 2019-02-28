#' Compute the total number of accession proteins per species 
#' 
#' Summarizes a dataframe of protein ids and return the total number of accessions 
#' per organism. 
#' 
#' @importFrom dplyr %>% count
#' 
#' @param my_accessions A data frame with accession protein ids and organisms 
#' 
#' @usage accessions_by_spp(my_accessions)
#'   
#' @seealso \code{\link{getAccessions}} to create the data frame with acession 
#'   id and organism for each protein identifier.
#' 
#' @return A \code{data.frame} of summarized results including columns:
#' \itemize{
#' \item organism
#' \item n   
#'   
#' @examples
#' my_prots = data.frame(accession = c("XP_014620925", "XP_003546066", 
#'    "XP_025640041", "XP_019453956", "XP_006584791", "XP_020212415", 
#'    "XP_017436622", "XP_004503803", "XP_019463844"),
#'    organism =  c("Glycine max", "Glycine max", "Arachis hypogaea",
#'    "Lupinus angustifolius", "Glycine max", "Cajanus cajan", 
#'    "Vigna angularis", "Cicer arietinum", "Lupinus angustifolius"))
#' accessions_by_spp(my_prots)
#'  
#' @author Jose V. Die 
#'  
#' @export


accessions_by_spp <- function(my_accessions){
  
  my_accessions %>% count(organism) 
  
}

utils::globalVariables(c("organism", "n"))
