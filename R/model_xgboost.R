#' @export
XGBoost = R6Class(
  "XGBoost",
  inherit = Model,
  public = list(
    params = list(
      train = list(nrounds = 100),
      predict = list()),

    preprocess_ = function(X) {
      as.matrix(self$preprocess(X))
    },

    train = function(X, y) {
      params = self$params$train
      params$data = xgboost::xgb.DMatrix(self$preprocess_(X), label = as.matrix(y))
      self$model = do.call(xgboost::xgb.train, params)
    },

    predict = function(X) {
      xgboost:::predict.xgb.Booster(self$model, xgboost::xgb.DMatrix(self$preprocess_(X)))
    },

    save = function(j) {
      xgboost::xgb.save(self$model, as.character(j))
    },

    load = function(j) {
      j = as.character(j)
      if(file.exists(j)) {
        self$model = xgboost::xgb.load(j)
      } else {
        self$model = NULL
      }
    }
  )
)

