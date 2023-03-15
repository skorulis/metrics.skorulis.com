//Created by Alexander Skorulis on 16/1/2023.

import ASKCore
import SwiftUI
import Shared
import FirebaseCore

@main
struct MetricsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    private let ioc = IOC(purpose: .normal)
    
    init() {
        FirebaseApp.configure()
        let plugins = ioc.resolve(PluginManager.self)
        delegate.ioc = ioc
        
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
