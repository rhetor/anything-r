# raw_tcp_server.R
library(processx)

# 最底层的TCP服务器实现
RawTcpServer <- R6::R6Class(
  "RawTcpServer",
  public = list(
    port = NULL,
    server_socket = NULL,
    is_running = FALSE,
    connections = list(),
    
    initialize = function(port = 3838) {
      self$port <- port
    },
    
    
    # 启动TCP服务器
    start = function() {
      cat("启动原始TCP服务器在端口", self$port, "...\n")
      
      # 使用processx调用系统工具创建TCP服务器
      self$server_socket <- processx::process$new(
        "Rscript",
        args = c("-e", shQuote(private$get_tcp_server_script())),
        stdout = "|",
        stderr = "|"
      )
      
      self$is_running <- TRUE
      cat("TCP服务器已启动\n")
      
      # 监控输出
      private$monitor_output()
    },
    
    
    # 停止服务器
    stop = function() {
      if (!is.null(self$server_socket)) {
        self$server_socket$kill()
      }
      self$is_running <- FALSE
      cat("TCP服务器已停止\n")
    },
    
    # 发送数据到指定连接
    send_data = function(connection_id, data) {
      # 在实际实现中，这里会通过管道或socket发送数据
      cat("发送数据到连接", connection_id, ":", data, "\n")
    }
  ),
  
  private = list(
    # 获取TCP服务器R脚本
    get_tcp_server_script = function() {
      script <- '
      # 原始TCP服务器实现
      library(socket)

      port <- 3838

      # 创建服务器socket
      server_socket <- socketConnection(
        port = port,
        server = TRUE,
        blocking = TRUE,
        open = "r+"
      )

      cat("TCP服务器监听端口", port, "...\\\\n")
      connection_count <- 0

      tryCatch({
        while(TRUE) {
          cat("等待新连接...\\\\n")

          # 接受客户端连接 (简化版)
          client_socket <- socketConnection(
            port = port,
            server = FALSE,
            blocking = TRUE,
            open = "r+"
          )

          connection_count <- connection_count + 1
          cat("接受新连接 #", connection_count, "\\\\n")

          # 处理客户端请求
          tryCatch({
            while(TRUE) {
              # 读取数据
              data <- readLines(client_socket, n = 1)
              if (length(data) == 0) break

              cat("收到原始数据: ", data, "\\\\n")

              # 解析HTTP请求
              if (grepl("GET|POST|HEAD", data)) {
                private$handle_http_request(client_socket, data)
              }

              # 简单响应
              response <- "HTTP/1.1 200 OK\\\\r\\\\nContent-Type: text/plain\\\\r\\\\n\\\\r\\\\nHello from Raw TCP Server"
              writeLines(response, client_socket)
            }
          }, error = function(e) {
            cat("连接错误:", e$message, "\\\\n")
          })

          close(client_socket)
        }
      }, error = function(e) {
        cat("服务器错误:", e$message, "\\\\n")
      })

      close(server_socket)
      '
      return(script)
    },
    
    # 监控服务器输出
    monitor_output = function() {
      # 在实际实现中，这里会读取服务器进程的输出
      cat("开始监控服务器输出...\n")
    },
    
    # 处理HTTP请求
    handle_http_request = function(socket, request_line) {
      cat("处理HTTP请求:", request_line, "\n")
    }
  )
)
