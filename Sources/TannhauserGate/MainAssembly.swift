import NIO
import Swinject

class MainAssembly {
    public func buildContainer() -> Container {
        let container = Container()

        container.register(ClientChannelHandler.self) { r in 
            return ClientChannelHandler() 
        }

        container.register(BasePipelineProvider.self) { r in
            BasePipelineProvider(clientChannelHandlerProvider: r.resolve(Provider<ClientChannelHandler>.self)!)
        }

        container.register(MultiThreadedEventLoopGroup.self) { r, count in 
            MultiThreadedEventLoopGroup(numberOfThreads: count) 
        }

        container.register(ServerBootstrap.self) { (r: Swinject.Resolver, bossGroup: MultiThreadedEventLoopGroup, workerGroup: MultiThreadedEventLoopGroup) -> ServerBootstrap in 
            let basePipelineProvider: BasePipelineProvider = r.resolve(BasePipelineProvider.self)!
            let bootstrap: ServerBootstrap = ServerBootstrap(group: bossGroup, childGroup: workerGroup)
                // Specify backlog and enable SO_REUSEADDR for the server itself
                .serverChannelOption(ChannelOptions.backlog, value: 256)
                // Enable SO_REUSEADDR for the accepted Channels
                .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
                // every time we get a new connection we will get a new pipeline initializer
                .childChannelInitializer(basePipelineProvider.buildBasePipeline())
                .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
                .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
                .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())
            return bootstrap
        }




        return container
    }
}