import NIO
import Swinject

class BasePipelineProvider {
    private let clientChannelHandlerProvider: Provider<ClientChannelHandler>

    required init(clientChannelHandlerProvider: Provider<ClientChannelHandler>) {
        self.clientChannelHandlerProvider = clientChannelHandlerProvider
    }

    public func buildBasePipeline() -> (Channel) -> EventLoopFuture<Void> {
        return { [weak self] channel in 
            return channel.pipeline.addHandler(self!.clientChannelHandlerProvider.instance)
        }
    }
}