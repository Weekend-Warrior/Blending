#' @export
Mlt_Caret = R6Class(
  "Mlt_Caret",
  inherit = Caret,
  public = list(
    train = function(X, y) {
      params = self$train_param
      params$x = self$preprocess(X)
      params$y = as.factor(y)
      self$model = do.call(caret::train, params)
    },

    predict = function(X) {
      as.integer(predict(self$model, self$preprocess(X))) - 1
    }
  )
)

#' @export
Mlt_XGBoost = R6Class(
  "Mlt_XGBoost",
  inherit = XGBoost,
  public = list(
    train_param = list(nrounds = 100, objective = "multi:softprob"),
    train = function(X, y) {
      params = self$train_param
      params$num_class = max(y) + 1
      params$data = xgboost::xgb.DMatrix(self$preprocess(X), label = as.vector(y))
      self$model = do.call(xgboost::xgb.train, params)
    },

    predict = function(X) {
      xgboost:::predict.xgb.Booster(self$model, xgboost::xgb.DMatrix(self$preprocess(X)), reshape = TRUE)
    }
  )
)


#' @export
Mlt_LightGBM = R6Class(
  "Mlt_LightGBM",
  inherit = LightGBM,
  public = list(
    train_param = list(
      verbose = 0,
      params = list(
        objective = "multiclass"),
      nrounds = 100,
      min_data=1
    ),

    train = function(X, y) {
      params = self$train_param
      params$num_class = max(y) + 1
      params$data = lightgbm::lgb.Dataset(self$preprocess(X), label = as.vector(y))
      self$model = do.call(lightgbm::lgb.train, params)
    },

    predict = function(X) {
      lightgbm:::predict.lgb.Booster(self$model, self$preprocess(X), reshape = TRUE)
    }
  )
)

#' @export
Mlt_MLP = R6Class(
  "Mlt_MLP",
  inherit = MLP,
  public = list(
    train_param = list(
      num.round = 100,
      array.layout = "rowmajor",
      array.batch.size = 1,
      initializer = mx.init.Xavier(),
      optimizer = "rmsprop",
      out_node = 1,
      out_activation = "softmax"
    )
  )
)

