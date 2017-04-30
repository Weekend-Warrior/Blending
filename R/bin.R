#' @export
Bin_Caret = R6Class(
  "Bin_Caret",
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
Bin_XGBoost = R6Class(
  "Bin_XGBoost",
  inherit = XGBoost,
  public = list(
    train_param = list(nrounds = 100, objective = "binary:logistic")
  )
)


#' @export
Bin_LightGBM = R6Class(
  "Bin_LightGBM",
  inherit = LightGBM,
  public = list(
    train_param = list(
      verbose = 0,
      params = list(
        objective = "binary"),
      nrounds = 100,
      min_data=1
    )
  )
)

#' @export
Bin_MLP = R6Class(
  "Bin_MLP",
  inherit = MLP,
  public = list(
    train_param = list(
      num.round = 100,
      array.layout = "rowmajor",
      array.batch.size = 1,
      initializer = mx.init.Xavier(),
      optimizer = "rmsprop",
      out_node = 1,
      out_activation = "logistic"
    )
  )
)

