# #' Blending cross validation
# #'
# #' @export
# CVblending = function(
#   X, y,
#   models, params, preprocesses = NULL, objective = c("regression", "classification"),
#   test_prop = 0.1, train_prop = switch(length(models, "1" = 1, "2" = c(0.9, 0.1), "3" = c(0.7, 0.2, 0.1)))) {
#
#   combinations = ""
#
#   accuracy = rep(NA, length(combinations))
#
#   for (i in 1:length(combinations)) {
#     accuracy[i] = Blending$new(X, y, models, combinations[[i]], preprocesses, objective, test_prop, train_prop)$accuracy
#   }
#
#   i = which.max(accuracy)
#
#   Blending$new(X, y, models, combinations[[i]], objective, test_prop, train_prop, preprocesses)
# }

#' Blending
#'
#' @param X data.frame of independent variable
#' @param y vector of dependent variable
#' @param models list of layers, each layer is a list of blending model class
#' @param params list of parameters for corresponding model
#' @param objective what kind of problem
#' @param test_prop what's the proportion of test data
#' @param train_prop what's the proportion of data for each layer training
#' @return a blending model
#' @examples
#' # regression
#' models = list(
#'   list(Caret, XGBoost),
#'   list(XGBoost))
#'
#' paramses = list(
#'   list(list(method = 'bridge'), list(nrounds = 50)),
#'   list(list(nrounds = 5)))
#'
#' preprocesses = default_preprocesses(models)
#'
#' X = iris[,1:3]
#' y = iris[,4]
#' m = blending(X, y, models, paramses, preprocesses, objective = "regression")
#' predict(m, X)
#'
#' # classification
#' models = list(
#'   list(XGBoost, XGBoost),
#'   list(XGBoost))
#'
#' paramses = list(
#'   list(list(nrounds = 50, objective = "multi:softmax", num_class = 3), list(nrounds = 10, objective = "multi:softmax", num_class = 3)),
#'   list(list(nrounds = 5, objective = "multi:softmax", num_class = 3)))
#'
#' preprocesses = default_preprocesses(models)
#'
#' X = iris[,1:4]
#' y = iris[,5]
#' m = blending(X, y, models, paramses, preprocesses, objective = "classification")
#' predict(m, X)
#' @export
blending = function(
  X, y,
  models, paramses, preprocesses = NULL, objective = c("regression", "classification"),
  test_prop = 0.1, train_prop = switch(length(models), "1" = 1, "2" = c(0.9, 0.1), "3" = c(0.7, 0.2, 0.1))) {
  Blending$new(X, y, models, paramses, preprocesses, match.arg(objective), test_prop, train_prop)
}


#' Blending prediction
#'
#' @param model
#' @param X
#' @return prediction value
#' @export
predict.Blending = function(model, X) {
  model$predict(X)
}

#' Blending save
#'
#' @param model
#' @param path
#' @export
save_Blending = function(model, path) {
  model$save(path)
}

#' Blending load
#'
#' @param model
#' @param path
#' @export
load_Blending = function(model, path) {
  model$load(path)
}

#' Default preprocesses
#'
#' @param model model list
#' @return default preprocesses list
#' @export
default_preprocesses = function(models) {
  lapply(models, function(m) {
    lapply(m, function(x) return(default_preprocess))
  })
}

default_preprocess = function(x) {
  x
}
