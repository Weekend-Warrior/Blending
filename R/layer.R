Layer = R6Class(
  classname = "Layer",
  public = list(
    m = NA,
    models = list(),

    initialize = function(X, y, models, paramses, preprocesses) {
      self$m = length(models)

      for (i in 1:self$m) {
        self$models[[i]] = models[[i]]$new(X, y, paramses[[i]], preprocesses[[i]])
      }
    },

    predict = function(X) {
      result = matrix(NA, nrow = nrow(X), ncol = self$m)
      for (i in 1:self$m) {
        result[,i] = self$models[[i]]$predict(X)
      }
      result
    },

    save = function(i) {
      f = getwd()
      dir.create(paste0(f, "/", i), FALSE, TRUE)
      setwd(paste0(f, "/", i))

      for (j in 1:length(self$models)) {
        self$models[[j]]$save(as.character(j))
      }

      setwd(f)
    },

    load = function(i) {
      f = getwd()
      dir.create(paste0(f, "/", i), FALSE, TRUE)
      setwd(paste0(f, "/", i))

      for (j in 1:length(self$models)) {
        self$models[[j]]$load(as.character(j))
      }

      setwd(f)
    }
  )
)

