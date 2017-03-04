#' @export
LightGBM = R6Class(
  "LightGBM",
  inherit = Model,
  public = list(
    params = list(
      train = list(
        params = list(
          objective = "regression",
          metric = "l2"),
        nrounds = 100,
        min_data=1
      ),
      predict = list()
    ),

    preprocess_ = function(X) {
      as.matrix(self$preprocess(X))
    },

    train = function(X, y) {
      params = self$params$train
      params$data = lightgbm::lgb.Dataset(self$preprocess_(X), label = as.matrix(y))
      self$model = do.call(lightgbm::lgb.train, params)
    },

    predict = function(X) {
      lightgbm:::predict.lgb.Booster(self$model, self$preprocess_(X))
    },

    save = function(j) {
      lightgbm::lgb.save(self$model, as.character(j))
    },

    load = function(j) {
      j = as.character(j)
      if(file.exists(j)) {
        self$model = lightgbm::lgb.load(j)
      } else {
        self$model = NULL
      }
    }
  )
)

