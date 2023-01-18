//Created by Alexander Skorulis on 16/1/2023.

import ASKCore
import SwiftUI
import Shared
import FirebaseCore

@main
struct MetricsApp: App {
    
    private let ioc = IOC(purpose: .normal)
    
    init() {
        FirebaseApp.configure()
        let plugins = ioc.resolve(PluginManager.self)
        plugins.register(plugin: RescueTimePlugin())
        plugins.register(plugin: GithubPlugin())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ioc.resolve())
                .environment(\.factory, ioc)
        }
    }
}
