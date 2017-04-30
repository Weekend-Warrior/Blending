#' @export
Caret = R6Class(
  "Caret",
  inherit = Model,
  public = list(
    train = function(X, y) {
      params = self$train_param
      params$x = self$preprocess(X)
      params$y = y
      self$model = do.call(caret::train, params)
    },

    predict = function(X) {
      as.vector(predict(self$model, self$preprocess(X)))
    }
  )
)

#' @export
XGBoost = R6Class(
  "XGBoost",
  inherit = Model,
  public = list(
    train_param = list(nrounds = 100),

    train = function(X, y) {
      params = self$train_param
      params$data = xgboost::xgb.DMatrix(self$preprocess(X), label = as.vector(y))
      self$model = do.call(xgboost::xgb.train, params)
    },

    predict = function(X) {
      xgboost:::predict.xgb.Booster(self$model, xgboost::xgb.DMatrix(self$preprocess(X)))
    },

    save = function(i, j) {
      xgboost::xgb.save(self$model, paste0(i, "_", j))
    },

    load = function(i, j) {
      f = paste0(i, "_", j)
      if(file.exists(f)) {
        self$model = xgboost::xgb.load(f)
      } else {
        self$model = NULL
      }
    }
  )
)

#' @export
LightGBM = R6Class(
  "LightGBM",
  inherit = Model,
  public = list(
    train_param = list(
      verbose = 0,
      params = list(
        objective = "regression",
        metric = "l2"),
      nrounds = 100,
      min_data=1
    ),

    train = function(X, y) {
      params = self$train_param
      params$data = lightgbm::lgb.Dataset(self$preprocess(X), label = as.vector(y))
      self$model = do.call(lightgbm::lgb.train, params)
    },

    predict = function(X) {
      lightgbm:::predict.lgb.Booster(self$model, self$preprocess(X))
    },

    save = function(i, j) {
      lightgbm::lgb.save(self$model, paste0(i, "_", j))
    },

    load = function(i, j) {
      f = paste0(i, "_", j)
      if(file.exists(f)) {
        self$model = lightgbm::lgb.load(f)
      } else {
        self$model = NULL
      }
    }
  )
)

#' @export
MLP = R6Class(
  "MLP",
  inherit = Model,
  public = list(
    train_param = list(
      num.round = 100,
      array.layout = "rowmajor",
      array.batch.size = 1,
      initializer = mx.init.Xavier(),
      optimizer = "rmsprop",
      out_node = 1,
      out_activation = "rmse"
    ),

    train = function(X, y) {
      params = self$train_param
      params$data = data.matrix(self$preprocess(X))
      params$label = y
      params$arg.params = self$model$arg.params
      params$aux.params = self$model$aux.params
      self$model = do.call(mxnet::mx.mlp, params)
    },

    predict = function(X) {
      as.vector(mxnet:::predict.MXFeedForwardModel(self$model, data.matrix(self$preprocess(self$preprocess(X))), array.layout = "rowmajor"))
    },

    save = function(i, j) {
      mxnet::mx.model.save(self$model, paste0(i, "_", j), 0)
    },

    load = function(i, j) {
      f = paste0(i, "_", j)
      if(file.exists(paste0(f, "-symbol.json"))) {
        self$model = mxnet::mx.model.load(f, 0)
        self$train_param$symbol = self$model$symbol
      } else {
        self$model = NULL
      }
    }
  )
)

#' @export
FeedForward = R6Class(
  "FeedForward",
  inherit = MLP,
  public = list(
    train_param = list(
      num.round = 100,
      array.layout = "rowmajor",
      array.batch.size = 1,
      initializer = mx.init.Xavier(),
      optimizer = "rmsprop"
    ),
    train = function(X, y) {
      params = self$train_param
      params$X = data.matrix(self$preprocess(X))
      params$y = y
      params$arg.params = self$model$arg.params
      params$aux.params = self$model$aux.params
      self$model = do.call(mxnet::mx.model.FeedForward.create, params)
    }
  )
)
