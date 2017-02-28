#' @export
Caret = R6Class(
  "Caret",
  inherit = Model,
  public = list(
    train = function(X, y) {
      params = self$params
      params$x = self$preprocess(X)
      params$y = y
      self$model = do.call(caret::train, params)
    },

    predict = function(X) {
      predict(self$model, X)
    }
  )
)

