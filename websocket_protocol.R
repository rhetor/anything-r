# websocket_protocol.R
WebSocketProtocol <- R6::R6Class(
  "WebSocketProtocol",
  public = list(
    # WebSocket握手
    do_handshake = function(http_request) {
      # 检查是否是WebSocket升级请求
      if (http_request$headers[['Upgrade']] != 'websocket') {
        return(NULL)
      }
      
      # 计算Sec-WebSocket-Accept
      key <- http_request$headers[['Sec-WebSocket-Key']]
      guid <- "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
      accept_key <- openssl::base64_encode(openssl::sha1(paste0(key, guid)))
      
      # 返回握手响应
      response <- list(
        status = 101,
        headers = list(
          'Upgrade' = 'websocket',
          'Connection' = 'Upgrade',
          'Sec-WebSocket-Accept' = accept_key
        ),
        body = ""
      )
      
      return(response)
    },
    
    # 解析WebSocket帧
    parse_frame = function(raw_data) {
      # 简化的WebSocket帧解析
      # 在实际实现中，这里会处理操作码、掩码、长度等
      cat("解析WebSocket帧，数据长度:", length(raw_data), "\n")
      
      # 返回模拟的解析结果
      list(
        opcode = 1,
        # 文本帧
        payload = rawToChar(raw_data),
        length = length(raw_data)
      )
    },
    
    # 构建WebSocket帧
    build_frame = function(payload, opcode = 1) {
      # 简化的WebSocket帧构建
      payload_bytes <- charToRaw(as.character(payload))
      payload_length <- length(payload_bytes)
      
      # 构建帧头
      if (payload_length <= 125) {
        frame_header <- as.raw(c(0x80 | opcode, payload_length))
      } else if (payload_length <= 65535) {
        frame_header <- as.raw(c(
          0x80 | opcode,
          126,
          as.integer(payload_length / 256),
          as.integer(payload_length %% 256)
        ))
      } else {
        stop("Payload too large")
      }
      
      # 组合帧
      frame <- c(frame_header, payload_bytes)
      return(frame)
    }
  )
)
