#' @export
build_matrix = function(data, formula) {
  model.matrix(formula, data)
}

#' @export
to_classes = function(x) {
  as.integer(as.factor(x)) - 1
}
