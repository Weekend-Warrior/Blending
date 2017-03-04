Model = R6Class(
  classname = "Model",
  public = list(
    model = NULL,
    preprocess = NULL,
    params = list(train = list(), predict = list()),

    initialize = function(X, y, params, preprocess) {
      for (n in names(params$train)) {
        self$params$train[[n]] = params[[n]]
      }
      for (n in names(params$predict)) {
        self$params$predict[[n]] = params[[n]]
      }
      self$preprocess = preprocess
      self$model = self$train(X, y)
    },

    train = function(X, y) {
      stop("Not Implemented")
    },

    predict = function(X) {
      stop("Not Implemented")
    },

    save = function(i) {
      saveRDS(list(model = self$model, params = self$params), as.character(i))
    },

    load = function(i) {
      raw = readRDS(as.character(i))
      self$model = raw$model
      self$params = raw$params
    }
  )
)

