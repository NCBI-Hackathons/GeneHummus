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
#' @importFrom rentrez entrez_summary
#'
#' @return
#' print out the description label for the candidate architectures that
#' contain the proteins we are looking for.
#'
#' @examples 
#' \dontshow{
#' filtered_archids <- c("12034188", "12034184","12034182")
#' getArch_labels(filtered_archids)}
#' \donttest{
#' filtered_archids <- filterArch_ids(archs_ids, my_filter)
#' getArch_labels(filtered_archids)}
#'
#' @author Jose V. Die
#'
#' @export


getArch_labels <-
function(arch_ids) {

  for(id in arch_ids) {
    my_label_sum = entrez_summary(db = "sparcle", id = id)
    print(paste(id, my_label_sum$displabel))

  }

}
