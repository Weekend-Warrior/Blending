#' @export
Stacking = R6Class(
  classname = "Stacking",
  public = list(
    name = NA,
    layers = list(),

    initialize = function(name, models) {
      self$name = name
      for (i in 1:max(models$level)) {
        self$layers[[i]] = Layer$new(models %>% filter(level == i))
      }
    },

    train = function(x, y) {
      # x: id, vars
      # y: id, var
      x = x %>% arrange(id)
      y = y %>% arrange(id)
      if (!all(x$id == y$id)) {
        stop("ID not matching...")
      }
      id = x$id

      size = floor(nrow(x) * switch(
        length(self$layers),
        "1" = c(0.9, 0.1),
        "2" = c(0.81, 0.09, 0.1),
        "3" = c(0.63, 0.18, 0.09, 0.1)
      ))

      size[length(size) - 1] = size[length(size) - 1] + nrow(x) - sum(size)

      levels = data.frame(id = id, level = sample(unlist(mapply(rep, length(self$layers):0, size))))
      for (i in length(self$layers):1) {
        train_x = x %>% inner_join(levels) %>% filter(level == i) %>% select(-level) %>% arrange(id)
        train_y = y %>% filter(id %in% train_x$id) %>% arrange(id)
        self$layers[[i]]$train(train_x, train_y)
        x = self$layers[[i]]$predict(
          x %>% inner_join(levels) %>% filter(level < i) %>% select(-level))
      }
    },

    predict = function(x) {
      for (i in length(self$layers):1) {
        x = self$layers[[i]]$predict(x)
      }
      x
    },

    save = function() {
      f = getwd()
      dir.create(paste0(f, "/model/", self$name), FALSE, TRUE)
      setwd(paste0(f, "/model/", self$name))

      for (i in 1:length(self$layers)) {
        self$layers[[i]]$save(i)
      }

      setwd(f)
    },

    load = function() {
      f = getwd()
      dir.create(paste0(f, "/model/", self$name), FALSE, TRUE)
      setwd(paste0(f, "/model/", self$name))

      for (i in 1:length(self$layers)) {
        self$layers[[i]]$load(i)
      }

      setwd(f)
    }
  )
)

