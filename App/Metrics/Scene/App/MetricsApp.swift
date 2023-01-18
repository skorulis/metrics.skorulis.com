//  Created by Alexander Skorulis on 8/1/2023.

import ASKCore
import FirebaseCore
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
            ContentView(viewModel: ioc.resolve())
                .environment(\.factory, ioc)
        }
    }
}
