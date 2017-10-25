rm(list = ls())
library(httpuv)
library(jsonlite)
source("util.R")

source("my_util.R")
html_filename <- "logistic_regression_app.html"
user_function <- function(msg) {
  in_msg <- fromJSON(msg)
  # Create and extract data
  grid_data <- make_uniform_grid(0, 400, 20)  # this is a 'constant' df
  train_data <- data.frame(x1 = in_msg$x1, x2 = in_msg$x2, y = in_msg$y)
  # print(train_data)
  # Refit models
  glm_model <- glm(y ~ ., data = train_data, family = binomial())
  grid_data[['y']] <- predict(glm_model, grid_data[,1:2], type = 'response')
  grid_data[['y']] <- round(grid_data[['y']])
  # Pass grid and data over
  out_msg <- list(x1 = grid_data[['x1']], 
                  x2 = grid_data[['x2']], 
                  y = grid_data[['y']])
  toJSON(out_msg)
}

app <- create_app(html_filename, user_function)
browseURL("http://localhost:9454/", browser = getOption("viewer"))
runServer("0.0.0.0", 9454, app, 250)
