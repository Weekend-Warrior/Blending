#' @export
Caret = R6Class(
  "Caret",
  inherit = Model,
  public = list(
    train = function(x, y) {
      params = self$params
      params$x = x
      params$y = y
      self$model = do.call(caret::train, params)
    },

    predict = function(x) {
      predict(self$model, x)
    }
  )
)

