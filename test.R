X = iris[,1:3]
y = iris[,4]

Caret$new(X, y, list(), function(x) x)$predict(X)
XGBoost$new(X, y, list(), function(x) x)$predict(X)
LightGBM$new(X, y, list(), function(x) x)$predict(X)
MLP$new(X, y, list(device = mx.gpu(0), hidden_node = 2), function(x) x)$predict(X)

data = mx.symbol.Variable('data')
fc1 = mx.symbol.FullyConnected(data, num_hidden=1)
lro = mx.symbol.LinearRegressionOutput(fc1)
FeedForward$new(X, y, list(symbol = lro, ctx = mx.gpu(0)), function(x) x)$predict(X)

