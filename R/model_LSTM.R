#' @export
LSTM = R6Class(
  "LSTM",
  inherit = Model,
  public = list(
    params = list(
      ctx = mx.cpu(),
      num.round = 1000,
      array.batch.size = 1,
      initializer = mx.init.Xavier(),
      optimizer = "rmsprop"),

    train = function(X, y) {
      params = self$params
      params$train.data = list(data = X, label = y)
      params$arg.params = self$model$arg.params
      params$aux.params = self$model$aux.params
      do.call(mxnet::mx.lstm, params)
    },

    predict = function(X) {
      mxnet::mx.lstm.forward(self$model, data.matrix(x))
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
