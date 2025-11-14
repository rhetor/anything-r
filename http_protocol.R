# http_protocol.R
HttpProtocol <- R6::R6Class(
  "HttpProtocol",
  public = list(
    # 解析HTTP请求
    parse_request = function(raw_data) {
      lines <- strsplit(raw_data, "\r\n")[[1]]
      
      if (length(lines) == 0)
        return(NULL)
      
      # 解析请求行
      request_line <- lines[1]
      parts <- strsplit(request_line, " ")[[1]]
      
      if (length(parts) < 3)
        return(NULL)
      
      request <- list(
        method = parts[1],
        path = parts[2],
        protocol = parts[3],
        headers = list(),
        body = NULL
      )
      
      # 解析头部
      i <- 2
      while (i <= length(lines) &&
             lines[i] != "") {
        header_line <- lines[i]
        header_parts <- strsplit(header_line, ": ")[[1]]
        if (length(header_parts) >= 2) {
          request$headers[[header_parts[1]]] <- header_parts[2]
        }
        i <- i + 1
      }
      
      # 解析body (如果有)
      if (i < length(lines)) {
        request$body <- paste(lines[(i + 1):length(lines)], collapse = "\r\n")
      }
      
      return(request)
    },
    
    # 构建HTTP响应
    build_response = function(status = 200,
                              headers = list(),
                              body = "") {
      status_text <- switch(
        as.character(status),
        "200" = "200 OK",
        "404" = "404 Not Found",
        "500" = "500 Internal Server Error",
        paste(status, "Unknown")
      )
      
      response <- paste0("HTTP/1.1 ", status_text, "\r\n")
      
      # 默认头部
      default_headers <- list(
        'Content-Type' = 'text/html; charset=utf-8',
        'Connection' = 'close',
        'Content-Length' = nchar(body, type = "bytes")
      )
      
      # 合并头部
      all_headers <- modifyList(default_headers, headers)
      
      for (name in names(all_headers)) {
        response <- paste0(response, name, ": ", all_headers[[name]], "\r\n")
      }
      
      response <- paste0(response, "\r\n", body)
      return(response)
    },
    
    # 生成HTML响应
    html_response = function(content, status = 200) {
      self$build_response(status = status, body = content)
    },
    
    # 生成JSON响应
    json_response = function(data, status = 200) {
      json_body <- jsonlite::toJSON(data, auto_unbox = TRUE)
      self$build_response(
        status = status,
        headers = list('Content-Type' = 'application/json'),
        body = json_body
      )
    }
  )
)