sample_int_ratio = function(n, r) {
  i = diff(c(0, floor(quantile(1:n, cumsum(r)))))
  sample(unlist(sapply(1:length(i), function(x) rep(x, i[x])))) - 1
}

update_param = function(default, customize) {
  for (name in names(customize)) {
    default[[name]] = customize[[name]]
  }
  default
}

Model = R6Class(
  "Model",
  list(
    train_param = NULL,
    predict_param = NULL,
    model = NULL,

    initialize = function(train_param = NULL, predict_param = NULL) {
      self$train_param = update_param(self$train_param, train_param)
      self$predict_param = update_param(self$predict_param, predict_param)
    },

    train = function(X, y) {
      stop("Not Implemented")
    },

    predict = function(X) {
      stop("Not Implemented")
    },

    save = function(i, j) {
      saveRDS(list(train_param = self$train_param, predict_param = self$predict_param, model = self$model),
              paste0(i, "_", j))
    },

    load = function(i, j) {
      f = paste0(i, "_", j)
      if(file.exists(f)) {
        tmp = readRDS(f)
        self$model = tmp$model
        self$train_param = tmp$train_param
        self$predict_param = tmp$predict_param
      }
    }
  )
)

Layer = R6Class(
  "Layer",
  list(
    n = NA,
    player = NULL,
    models = NULL,

    initialize = function(models, player = NULL) {
      self$n = length(models)
      self$models = models
      self$player = player
    },

    add_previous_prediction = function(X) {
      if (is.null(self$player)) {
        return(X)
      } else {
        return(cbind(X, self$player$predict(X)))
      }
    },

    train = function(X, y) {
      X = self$add_previous_prediction(X)
      invisible(lapply(self$models, function(model) model$train(X, y)))
    },

    predict = function(X) {
      X = self$add_previous_prediction(X)
      do.call(cbind, lapply(self$models, function(model) model$predict(X)))
    },

    save = function(i) {
      for (j in 1:self$n) {
        self$models[[i]]$save(i, j)
      }
    },

    load = function(i) {
      for (j in 1:self$n) {
        self$models[[i]]$load(i, j)
      }
    }
  )
)

Blending = R6Class(
  "Blending",
  list(
    n = NA,
    layers = NULL,

    initialize = function(layers) {
      self$n = length(layers)
      self$layers = layers
      for (i in 2:self$n) {
        self$layers[[i]]$player = self$layers[[i-1]]
      }
    },

    train = function(X, y, test_prop = 0.1, train_prop = c(0.7, 0.3), metric = function(yhat, y) sqrt(mean((y-yhat)^2))) {
      n = length(y)

      ratio = c(test_prop, (1 - test_prop) * train_prop)
      index = sample_int_ratio(n, ratio)

      test_X = X[index == 0,]
      test_y = y[index == 0]

      for (i in 1:self$n) {
        sub_index = index == i
        cat(sprintf("Train layer %d with %d observations\n", i, sum(sub_index)))
        self$layers[[i]]$train(X[sub_index,], y[sub_index])
      }

      if (test_prop > 0) {
        cat(sprintf("Metric on test set: %2.2f\n", metric(self$predict(test_X), test_y)))
      }
    },

    predict = function(X) {
      self$layers[[self$n]]$predict(X)
    },

    save = function() {
      current_wd = getwd()
      model_wd = paste0(current_wd, "/model_file")
      dir.create(model_wd, FALSE)
      setwd(model_wd)
      for (i in 1:self$n) {
        self$layers[[i]]$save(i)
      }
      setwd(current_wd)
    },

    load = function() {
      current_wd = getwd()
      model_wd = paste0(current_wd, "/model_file")
      for (i in 1:self$n) {
        self$layers[[i]]$load(i)
      }
      setwd(current_wd)
    }
  )
)

#' @export
blending = function(X, y, model_lists, test_prop = 0.1, train_prop = c(0.7, 0.3), metric = function(yhat, y) sqrt(mean((y-yhat)^2))) {
  layers = lapply(model_lists, function(model_list) Layer$new(model_list))
  ret = Blending$new(layers)
  ret$train(X, y, test_prop, train_prop, metric)
  ret
}
