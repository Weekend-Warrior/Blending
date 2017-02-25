Layer = R6Class(
  classname = "Layer",
  public = list(
    models = list(),

    initialize = function(models) {
      for (i in 1:nrow(models)) {
        self$models[[i]] = eval(parse(text = sprintf("%s$new(list(%s))", models[i,"model"], models[i,"params"])))
      }
    },

    train = function(x, y) {
      # x: id, vars
      # y: id, var
      for (m in self$models) {
        m$train(x %>% select(-id), y$y)
      }
    },

    predict = function(x) {
      # x: id, vars
      # ret: id, vars
      id = x$id
      ret = do.call(rbind, lapply(1:length(self$models), function(i) {
        data.frame(
          model = i,
          id = id,
          hat = self$models[[i]]$predict(x %>% select(-id)))
      }))
      dcast(ret, id~model, value.var = "hat")
    },

    save = function(i) {
      f = getwd()
      dir.create(paste0(f, "/", i), FALSE, TRUE)
      setwd(paste0(f, "/", i))

      for (j in 1:length(self$models)) {
        self$models[[i]]$save(as.character(j))
      }

      setwd(f)
    },

    load = function(i) {
      f = getwd()
      dir.create(paste0(f, "/", i), FALSE, TRUE)
      setwd(paste0(f, "/", i))

      for (j in 1:length(self$models)) {
        self$models[[i]]$load(as.character(j))
      }

      setwd(f)
    }
  )
)

