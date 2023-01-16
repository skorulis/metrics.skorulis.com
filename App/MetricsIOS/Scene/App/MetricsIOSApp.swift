//Created by Alexander Skorulis on 16/1/2023.

import ASKCore
import SwiftUI
import Shared

@main
struct MetricsApp: App {
    
    private let ioc = IOC(purpose: .normal)
    
    init() {
        let plugins = ioc.resolve(PluginManager.self)
        plugins.register(plugin: RescueTimePlugin())
        plugins.register(plugin: GithubPlugin())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.factory, ioc)
        }
    }
}
