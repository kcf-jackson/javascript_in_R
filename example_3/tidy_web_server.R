rm(list = ls())
library(httpuv)
library(jsonlite)
source("util.R")

html_filename <- "my_app.html"
user_function <- function(msg) {
  my_data <- fromJSON(msg)
  print(my_data)
  beta_1 <- my_data$x * 10
  beta_2 <- my_data$y
  my_data$x <- seq(-100, 100, length.out = 100)
  my_data$y <- boot::inv.logit(beta_1 + beta_2 * my_data$x)
  # print(my_data)
  toJSON(list(x = my_data$x, y = my_data$y))
}

app <- create_app(html_filename, user_function)
browseURL("http://localhost:9454/", browser = getOption("viewer"))
runServer("0.0.0.0", 9454, app, 250)
