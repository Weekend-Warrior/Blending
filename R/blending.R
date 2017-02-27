#' Blending class
#'
#' @export
Blending = R6Class(
  classname = "Blending",
  public = list(
    m = NA,
    layers = list(),
    objective = NULL,

    initialize = function(X, y, models, paramses, preprocesses, objective, test_prop, train_prop) {

      if (!all(sapply(models, length) == sapply(paramses, length))) {
        stop("Number of models do not match number of parameter list!")
      }

      if (nrow(X) != length(y)) {
        stop("Number of X do not match number of y!")
      }

      if (is.null(preprocesses)) {
        preprocesses = default_preprocesses(models)
      }

      n = length(y)
      level = self$level(n, test_prop, train_prop)

      self$objective = objective

      self$m = length(models)

      for (i in 1:self$m) {
        if (i == 1) {
          fullX = X
        } else {
          fullX = cbind(X, newX)
        }
        index = level == i
        self$layers[[i]] = Layer$new(fullX[index, ], y[index], models[[i]], paramses[[i]], preprocesses[[i]])
        newX = self$layers[[i]]$predict(fullX)
      }

      if (test_prop > 0) {
        if (objective == "regression") {
          cat()
        }
        if (objective == "classification") {
          cat()
        }
      } else {
        cat("No test set data!\n")
      }
    },

    level = function(n, test_prop, train_prop) {
      prop = c(train_prop * (1 - test_prop), test_prop)
      ns = diff(c(0, n * cumsum(prop)))
      sample(unlist(mapply(rep, 1:length(ns), ns)))
    },

    predict = function(X) {
      for (i in 1:self$m) {
        if (i == 1) {
          fullX = X
        } else {
          fullX = cbind(X, newX)
        }
        newX = self$layers[[i]]$predict(fullX)
      }
      newX
    },

    save = function(path) {
      curr = getwd()

      dir.create(path, FALSE, TRUE)
      setwd(path)

      for (i in 1:self$m) {
        self$layers[[i]]$save(i)
      }

      setwd(curr)
    },

    load = function(path) {
      curr = getwd()

      setwd(path)

      for (i in 1:self$m) {
        self$layers[[i]]$load(i)
      }

      setwd(curr)
    }
  )
)

