#' Build a list containing N elements per element list
#'
#' Split a vector into N elements, so that each element contain a given
#' length.
#'
#' @importFrom utils globalVariables
#'
#' @author Jose V. Die

sizeIds = 300
#if(getRversion() >= "2.15.1")  utils::globalVariables(sizeIds)

subsetIds <-
function(target, sizeIds) {

  # initializes an empty list
  vals = list()

  foo = sample(target, size = sizeIds, replace = FALSE)   # 1st sample
  vals[[1]] = foo                                         # add 1st element to the list

  # update vector
  target = target[! target %in% foo]

  i = 2

  while(length(target) >= sizeIds) {

    foo = sample(target, size = sizeIds, replace = FALSE) # n sample
    vals[[i]] = foo                                       # add n-th element to the list

    # update vector
    target = target[! target %in% foo]

    i = i+1

  }

  # remaining elements :
  if(length(target) > 0) {
    foo = sample(target, size = length(target), replace = FALSE)  # last sample
    vals[[i]] = foo                                               # add last element to the list

  }

  vals

}
