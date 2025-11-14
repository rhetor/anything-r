# test_simulated_httpuv.R
source("simulated_httpuv.R")
source("http_protocol.R")
source("websocket_protocol.R")

# 创建测试应用
test_app <- list(
  call = function(req) {
    cat("应用处理器被调用，路径:", req$PATH_INFO, "\n")
    
    if (req$PATH_INFO == "/") {
      return(list(
        status = 200,
        headers = list('Content-Type' = 'text/html'),
        body = '<h1>模拟Httpuv测试</h1><p>这是首页</p>'
      ))
    } else if (req$PATH_INFO == "/api/data") {
      return(list(
        status = 200,
        headers = list('Content-Type' = 'application/json'),
        body = '{"status": "success", "data": [1,2,3]}'
      ))
    } else {
      return(list(
        status = 404,
        headers = list('Content-Type' = 'text/plain'),
        body = '404 Not Found'
      ))
    }
  }
)

# 创建并启动模拟服务器
server <- SimulatedHttpuv$new(3838)
server$startServer(app = test_app)

# 运行服务
server$service()

# 测试HTTP协议解析
http <- HttpProtocol$new()
raw_request <- "GET /test HTTP/1.1\r\nHost: localhost\r\nUser-Agent: test\r\n\r\n"
parsed <- http$parse_request(raw_request)
cat("解析的请求:\n")
print(parsed)

# 测试WebSocket协议
ws <- WebSocketProtocol$new()
handshake_request <- list(headers = list(Upgrade = 'websocket', 'Sec-WebSocket-Key' = 'dGhlIHNhbXBsZSBub25jZQ=='))
handshake_response <- ws$do_handshake(handshake_request)
cat("WebSocket握手响应:\n")
print(handshake_response)