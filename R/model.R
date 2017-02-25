Model = R6Class(
  classname = "Model",
  public = list(
    model = NULL,
    params = list(),
    initialize = function(params) {
      for (n in names(params)) {
        self$params[[n]] = params[[n]]
      }
    },

    train = function(x, y) {
      # x: vars
      # y: var
      stop("Not Implemented")
    },

    predict = function(x) {
      # x: vars
      # ret: id, var
      stop("Not Implemented")
    },

    save = function(j) {
      saveRDS(list(model = self$model, params = self$params), paste0(j, ".", class(self)[1]))
    },

    load = function(j) {
      raw = readRDS(paste0(j, ".", class(self)[1]))
      self$model = raw$model
      self$params = raw$params
    }
  )
)

