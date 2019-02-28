#' Get the species name from the description sequence
#'
#' Parse a string vector with sequence descriptions (title and species) and
#' extract the species name.
#'
#' @usage
#' get_spp(description)
#'
#' @param description A string vector with the sequence description (title and species).
#'
#' @importFrom stringr str_sub str_locate
#'
#' @return
#' for each sequence description, extract the species name.
#'
#' @examples
#' desc <- "PREDICTED: auxin response factor 19-like isoform X1 [Glycine max]"
#' get_spp(desc)
#'
#' @author Jose V. Die
#'
#' @export


get_spp <-
function(description) {


  spp <- str_sub(description,
                 start = str_locate(description, "\\[")[1]+1,
                 end = str_locate(description, "\\]")[2]-1)
  spp
}
