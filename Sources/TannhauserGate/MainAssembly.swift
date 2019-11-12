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
        return container
    }
}