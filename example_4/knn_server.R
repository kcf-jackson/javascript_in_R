rm(list = ls())
library(httpuv)
library(jsonlite)
library(class)
source("util.R")

source("my_util.R")
html_filename <- "knn_app.html"
user_function <- function(msg) {
  in_msg <- fromJSON(msg)
  # Create and extract data
  grid_data <- make_uniform_grid(0, 400, 20)  # this is a 'constant' df
  train_data <- data.frame(x1 = in_msg$x1, x2 = in_msg$x2, y = in_msg$y)
  # print(train_data)
  # Refit models
  knn_pred <- knn(train_data[,1:2], grid_data[,1:2], train_data[,3])
  grid_data[['y']] <- as.numeric(as.character(knn_pred))
  # Pass grid and data over
  out_msg <- list(x1 = grid_data[['x1']], 
                  x2 = grid_data[['x2']], 
                  y = grid_data[['y']])
  toJSON(out_msg)
}

app <- create_app(html_filename, user_function)
browseURL("http://localhost:9454/", browser = getOption("viewer"))
runServer("0.0.0.0", 9454, app, 250)
