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

      self$objective = objective
      if (objective == "classification") {
        y = as.factor(y)
        private$class_tab = levels(y)
        y = as.integer(y) - 1L
      }

      self$m = length(models)

      n = length(y)
      prop = c(train_prop * (1 - test_prop), test_prop)
      ns = diff(c(0, n * cumsum(prop)))
      level = sample(unlist(mapply(rep, 1:length(ns), ns)))

      sink(tempfile())
      newX = self$train(X, y, models, paramses, preprocesses, test_prop, train_prop, level)
      sink(NULL)

      if (objective == "classification") {
        y = private$class_tab[y + 1]
        newX = private$class_tab[newX + 1]
      }

      if (test_prop > 0) {
        if (objective == "regression") {
          mse = mean((newX - y)[level == self$m + 1]^2)
          cat("MSE:\n", mse)
        }
        if (objective == "classification") {
          confusion_matrix = table(data.frame(true = y, predict = newX)[level == self$m + 1,])
          cat("confusion matrix:\n", confusion_matrix)
        }
      } else {
        cat("No test data!\n")
      }
    },

    train = function(X, y, models, paramses, preprocesses, test_prop, train_prop, level) {
      for (i in 1:self$m) {
        if (i == 1) {
          fullX = X
        } else {
          fullX = cbind(X, as.data.frame(newX))
        }
        index = level == i
        cat("Start training layer", i, "\n")
        self$layers[[i]] = Layer$new(fullX[index, ], y[index], models[[i]], paramses[[i]], preprocesses[[i]])
        cat("Stop training layer", i, "\n")
        newX = self$layers[[i]]$predict(fullX)
      }

      as.vector(newX)
    },

    predict = function(X) {
      for (i in 1:self$m) {
        if (i == 1) {
          fullX = X
        } else {
          fullX = cbind(X, as.data.frame(newX))
        }
        newX = self$layers[[i]]$predict(fullX)
      }
      if (self$objective == "classification") {
        newX = private$class_tab[newX + 1]
      }
      as.vector(newX)
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
  ),
  private = list(
    class_tab = NA
  )
)

