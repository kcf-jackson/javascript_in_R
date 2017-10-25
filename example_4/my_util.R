make_uniform_grid <- function(min0, max0, resolution = 100) {
  one_side_grid <- seq(min0, max0, length.out = resolution)
  grid_data <- expand.grid(one_side_grid, one_side_grid)
  grid_data <- data.frame(grid_data, 0)
  names(grid_data) <- c('x1', 'x2', 'y')
  grid_data
}
