library(Blending)
## Test Model Class
# # REG
#
# X = as.matrix(iris[,1:3])
# y = iris[,4]
#
# test = Caret$new(); test$train(X, y); test$predict(X)
# test = XGBoost$new(); test$train(X, y); test$predict(X)
# test = LightGBM$new(); test$train(X, y); test$predict(X)
# test = MLP$new(list(device = mx.gpu(0), hidden_node = 2)); test$train(X, y); test$predict(X)
#
# data = mx.symbol.Variable('data')
# fc1 = mx.symbol.FullyConnected(data, num_hidden=1)
# lro = mx.symbol.LinearRegressionOutput(fc1)
# test = FeedForward$new(list(symbol = lro, ctx = mx.gpu(0))); test$train(X, y); test$predict(X)
#
#
# # BIN
#
# X = as.matrix(iris[,1:4])
# y = to_classes(iris[,5]) == 0
#
# test = Bin_Caret$new(list()); test$train(X, y); test$predict(X)
# test = Bin_XGBoost$new(); test$train(X, y); test$predict(X)
# test = Bin_LightGBM$new(); test$train(X, y); test$predict(X)
# test = Bin_MLP$new(list(device = mx.gpu(0), hidden_node = 2)); test$train(X, y); test$predict(X)
#
# # MLT
#
# X = as.matrix(iris[,1:4])
# y = to_classes(iris[,5])
#
# test = Mlt_Caret$new(list(method = "ranger")); test$train(X, y); test$predict(X)
# test = Mlt_XGBoost$new(); test$train(X, y); test$predict(X)
# test = Mlt_LightGBM$new(); test$train(X, y); test$predict(X)
# test = Mlt_MLP$new(list(device = mx.gpu(0), hidden_node = 2)); test$train(X, y); test$predict(X)


## Test Layer Class
# # REG
#
# X = as.matrix(iris[,1:3])
# y = iris[,4]
#
# model_1 = XGBoost$new()
# model_2 = LightGBM$new()
#
# layer = Layer$new(list(model_1, model_2))
# layer$train(X, y)
# layer$predict(X)


## Test Blending Class
# # REG
#
# X = as.matrix(iris[,1:3])
# y = iris[,4]
#
# model_1_1 = XGBoost$new()
# model_1_2 = LightGBM$new()
# model_2_1 = XGBoost$new()
#
# layer_1 = Layer$new(list(model_1_1, model_1_2))
# layer_2 = Layer$new(list(model_2_1))
#
# blending = Blending$new(list(layer_1, layer_2))
#
# blending$train(X, y)
# blending$predict(X)

## Test blending function
# REG

X = as.matrix(iris[,1:3])
y = iris[,4]

model_1_1 = XGBoost$new()
model_1_2 = LightGBM$new()
model_2_1 = XGBoost$new()

model = blending(X, y, list(list(model_1_1, model_1_2), list(model_2_1)))
model$predict(X)

model$save()
model$load()
