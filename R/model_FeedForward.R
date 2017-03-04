#' @export
FeedForward = R6Class(
  "FeedForward",
  inherit = Model,
  public = list(
    params = list(
      train = list(
        num.round = 100,
        array.batch.size = 1,
        initializer = mx.init.Xavier(),
        optimizer = "rmsprop"
      ),
      predict = list()),

    train = function(x, y) {
      params = self$params$train
      params$X = data.matrix(x)
      params$y = y
      params$arg.params = self$model$arg.params
      params$aux.params = self$model$aux.params
      do.call(mxnet::mx.model.FeedForward.create, params)
    },

    predict = function(x) {
      mxnet:::predict.MXFeedForwardModel(self$model, data.matrix(x))
    },

    save = function(j) {
      mxnet::mx.model.save(self$model, j, 0)
    },

    load = function(j) {
      if(file.exists(paste0(j, "-symbol.json"))) {
        self$model = mxnet::mx.model.load(self$model_file, 0)
        self$params$symbol = self$model$symbol
      } else {
        self$model = NULL
      }
    }
  )
)
