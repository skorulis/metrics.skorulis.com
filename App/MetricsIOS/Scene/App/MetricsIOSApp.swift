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
        plugins.register(plugin: HealthKitPlugin())
        plugins.register(plugin: LocationPlugin())
        
        plugins.register(plugin: RescueTimeChartRenderer())
        plugins.register(plugin: GithubLineListRenderer())
        plugins.register(plugin: HealthKitRenderer())
        plugins.register(plugin: LocationRenderer())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ioc.resolve())
                .environment(\.factory, ioc)
        }
    }
}
