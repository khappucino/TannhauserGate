import NIO

class ClientChannelHandler: ChannelInboundHandler {
  typealias InboundIn = ByteBuffer
  typealias InboundOut = ByteBuffer

  let rando: Int

  required init() {
    rando = Int.random(in: 1..<5000) 
  }

  public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
    print(rando)
    context.fireChannelRead(data)
  }
}

