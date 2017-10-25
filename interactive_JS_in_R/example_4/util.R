html_to_string <- function(filepath, wsUrl) {
  vec0 <- readLines(filepath)
  has_script <- function(l) {length(grep("<script>", l)) > 0}
  script_index <- min(which(sapply(vec0, has_script)))
  # insert a websocket connection into a html file
  wsUrl_line <- sprintf("var ws = new WebSocket(%s);", wsUrl)
  vec1 <- c(vec0[1:script_index], wsUrl_line, vec0[(script_index+1):length(vec0)])
  paste(vec1, collapse = "\r\n")
}

create_ws_url <- function(address) {
  paste('"', "ws://", address, '"', sep = '')
}

create_app <- function(html_file, user_function) {
  list(
    call = function(req) {
      address <- ifelse(is.null(req$HTTP_HOST), req$SERVER_NAME, req$HTTP_HOST)
      wsUrl <- create_ws_url(address)
      list(
        status = 200L,
        headers = list('Content-Type' = 'text/html'),
        body = html_to_string(html_filename, wsUrl)
      )
    },
    onWSOpen = function(ws) {
      ws$onMessage(function(binary, message) {
        output <- user_function(message)
        ws$send(output)
      })
    }
  )
}
