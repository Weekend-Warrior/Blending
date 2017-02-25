#' @export
XGBoost = R6Class(
  "XGBoost",
  inherit = Model,
  public = list(
    params = list(nrounds = 100),

    train = function(x, y) {
      params = self$params
      params$data = xgboost::xgb.DMatrix(as.matrix(x), label = as.matrix(y))
      self$model = do.call(xgboost::xgb.train, params)
    },

    predict = function(x) {
      xgboost:::predict.xgb.Booster(self$model, xgboost::xgb.DMatrix(as.matrix(x)))
    },

    save = function(j) {
      xgboost::xgb.save(self$model, j)
    },

    load = function(j) {
      if(file.exists(j)) {
        self$model = xgboost::xgb.load(j)
      } else {
        self$model = NULL
      }
    }
  )
)

