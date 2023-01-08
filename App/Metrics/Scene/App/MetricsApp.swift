//  Created by Alexander Skorulis on 8/1/2023.

import ASKCore
import SwiftUI

@main
struct MetricsApp: App {
    
    private let ioc = IOC(purpose: .normal)
    
    init() {
        let plugins = ioc.resolve(PluginManager.self)
        plugins.register(plugin: RescueTimePlugin())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.factory, ioc)
        }
    }
}
