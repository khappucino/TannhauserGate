import NIO
import Dispatch
import Swinject

let container = MainAssembly().buildContainer()

let bossGroup: MultiThreadedEventLoopGroup = container.resolve(MultiThreadedEventLoopGroup.self, argument: 1)!
let workerGroup: MultiThreadedEventLoopGroup = container.resolve(MultiThreadedEventLoopGroup.self, argument: 4)!

let serverBootstrap = container.resolve(ServerBootstrap.self, arguments: bossGroup, workerGroup)!

defer {
    try! bossGroup.syncShutdownGracefully()
    try! workerGroup.syncShutdownGracefully()
}

let channel = try serverBootstrap.bind(host: "127.0.0.1", port: 8080).wait()

guard let localAddress = channel.localAddress else {
    fatalError("Address was unable to bind. Please check that the socket was not closed or that the address family was understood.")
}
print("Server started and listening on \(localAddress)")

// This will never unblock as we don't close the ServerChannel.
try channel.closeFuture.wait()
