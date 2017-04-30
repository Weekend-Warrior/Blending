#' @export
to_classes = function(x) {
  as.integer(as.factor(x)) - 1
}

#' @export
metric_mse = function(yhat, y) {
  sqrt(mean((y-yhat)^2))
}

#' @export
metric_auc = function(yhat, y) {
  f = y == 0
  t = y == 1

  fl = quantile(yhat[f], seq(0, 1, length.out = 100))
  tl = yhat[t]
  mean(sapply(fl, function(x) mean(tl >= x)))
}

#' @export
metric_accuracy = function(yhat, y) {
  sum(yhat == y) / length(y)
}

