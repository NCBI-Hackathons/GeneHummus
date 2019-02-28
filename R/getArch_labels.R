#' Get the description label for a protein architecture identifier
#'
#' Parses the architecture identifiers and extract their corresponding
#' labels.
#'
#' @usage
#' getArch_labels(arch_ids)
#'
#' @param arch_ids A string with the electronic identifiers.
#'
#' @seealso \code{filterArch_ids}
#'
#' @importFrom rentrez entrez_summary
#'
#' @return
#' print out the description label for the candidate architectures that
#'  contain the proteins we are looking for.
#'
#' @examples \dontrun{
#' filtered_ids <- filterArch_ids(archs_ids, my_filter)
#' getArch_labels(filtered_ids)}
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
