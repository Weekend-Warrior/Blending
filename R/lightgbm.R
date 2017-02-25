#' @export
LightGBM = R6Class(
  "LightGBM",
  inherit = Model,
  public = list(
    params = list(
      params = list(
        objective = "regression",
        metric = "l2"),
      nrounds = 100),

    train = function(x, y) {
      params = self$params
      params$data = lightgbm::lgb.Dataset(as.matrix(x), label = as.matrix(y))
      self$model = do.call(lightgbm::lgb.train, params)
    },

    predict = function(x) {
      lightgbm:::predict.lgb.Booster(self$model, as.matrix(x))
    },

    save = function(j) {
      lightgbm::lgb.save(self$model, j)
    },

    load = function(j) {
      if(file.exists(j)) {
        self$model = lightgbm::lgb.load(self$model_file)
      } else {
        self$model = NULL
      }
    }
  )
)

