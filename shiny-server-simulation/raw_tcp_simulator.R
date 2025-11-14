# raw_tcp_simulator.R

# 模拟TCP套接字类
SimulatedTCPSocket <- R6::R6Class(
  "SimulatedTCPSocket",
  public = list(
    port = NULL,
    host = NULL,
    is_server = NULL,
    is_connected = FALSE,
    buffer = character(0),
    
    initialize = function(host = "127.0.0.1",
                          port = 3838,
                          server = FALSE) {
      self$host <- host
      self$port <- port
      self$is_server <- server
      cat("创建",
          ifelse(server, "服务器", "客户端"),
          "TCP套接字:",
          host,
          ":",
          port,
          "\n")
    },
    
    # 模拟连接建立
    connect = function() {
      if (!self$is_server) {
        self$is_connected <- TRUE
        cat("客户端连接到", self$host, ":", self$port, "\n")
        return(TRUE)
      }
      return(FALSE)
    },
    
    # 模拟监听
    listen = function() {
      if (self$is_server) {
        self$is_connected <- TRUE
        cat("服务器开始在", self$host, ":", self$port, "监听\n")
        return(TRUE)
      }
      return(FALSE)
    },
    
    # 模拟接受连接
    accept = function() {
      if (self$is_server && self$is_connected) {
        cat("服务器接受新客户端连接\n")
        # 返回一个模拟的客户端套接字
        client_socket <- SimulatedTCPSocket$new(self$host, self$port, server = FALSE)
        client_socket$is_connected <- TRUE
        return(client_socket)
      }
      return(NULL)
    },
    
    # 模拟发送数据
    send = function(data) {
      if (self$is_connected) {
        cat("TCP发送数据:",
            substr(data, 1, 50),
            ifelse(nchar(data) > 50, "...", ""),
            "\n")
        return(TRUE)
      }
      return(FALSE)
    },
    
    # 模拟接收数据
    receive = function(timeout = 0) {
      if (self$is_connected && length(self$buffer) > 0) {
        data <- self$buffer[1]
        self$buffer <- self$buffer[-1]
        cat("TCP接收数据:",
            substr(data, 1, 50),
            ifelse(nchar(data) > 50, "...", ""),
            "\n")
        return(data)
      }
      return("")
    },
    
    # 模拟缓冲数据（用于测试）
    buffer_data = function(data) {
      self$buffer <- c(self$buffer, data)
    },
    
    # 关闭连接
    close = function() {
      self$is_connected <- FALSE
      cat("TCP连接关闭\n")
    }
  )
)