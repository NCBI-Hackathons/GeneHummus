#' Get the description label for a protein architecture identifier
#'
#' Parses the architecture identifiers and extract their corresponding
#' labels.
#'
#' @usage
#' getArch_labels(arch_ids)
#'
#' @param arch_ids A string with the architecture electronic identifiers.
#'
#' @seealso \code{filterArch_ids}
#'
#' @importFrom curl has_internet
#'
#' @return
#' print out the description label for the candidate architectures that
#' contain the proteins we are looking for.
#'
#' @examples 
#' \dontshow{
#' filtered_archids <- c("12034188", "12034184","12034182")
#' getArch_labels(filtered_archids)}
#' 
#' \donttest{
#' filtered_archids <- c("12034188", "12034184")
#' getArch_labels(filtered_archids)}
#'
#' @author Jose V. Die
#'
#' @export


getArch_labels <-
function(arch_ids) {
  
  if(!has_internet()) {
    message("This function requires Internet connection.")
  } else {
    tryCatch(
      expr = {labels_warning(arch_ids)}, 
      error = function(e) {message("NCBI servers are busy. Please try again a bit later.")},
      warning = function(w) {message("NCBI servers are busy. Please try again a bit later.")}
    )

      }

}
