//  Created by Alexander Skorulis on 16/1/2023.

import Foundation
import ASKCore
import Swinject
import SwinjectAutoregistration

public final class SharedAssembly: AutoModuleAssembly {
    public static var dependencies: [ModuleAssembly.Type] = [
        CoreModuleAssembly.self
    ]
    
    public init() {}
    
    public func assemble(container: Container) {
        registerBehaviors(container: container)
        registerServices(container: container)
        registerStores(container: container)
        registerViewModels(container: container)
        registerPlugins(container: container)
    }
    
    private func registerBehaviors(container: Container) {
        container.addBehavior(InstanceAggregation<SourcePlugin>(isChild: { $0 is SourcePlugin.Type }))
    }
    
    private func registerServices(container: Container) {
        container.autoregister(TokensService.self, initializer: TokensService.init)
            .inObjectScope(.container)
        
        container.autoregister(GithubHTTPService.self, initializer: GithubHTTPService.init)
            .inObjectScope(.container)
        
        container.autoregister(PluginManager.self, initializer: PluginManager.init)
            .inObjectScope(.container)
        
        container.autoregister(DataService.self, initializer: DataService.init)
        container.autoregister(FetchStatusService.self, initializer: FetchStatusService.init)
            .inObjectScope(.container)
    }
    
    private func registerViewModels(container: Container) {
        container.autoregister(ContentViewModel.self, initializer: ContentViewModel.init)
        container.autoregister(SettingsViewModel.self, initializer: SettingsViewModel.init)
        container.autoregister(FetchDataViewModel.self, initializer: FetchDataViewModel.init)
        container.autoregister(MetricsDashboardViewModel.self, initializer: MetricsDashboardViewModel.init)
        container.autoregister(LoginViewModel.self, initializer: LoginViewModel.init)
    }
    
    private func registerStores(container: Container) {
        container.autoregister(MetricsStore.self, initializer: MetricsStore.init)
            .inObjectScope(.container)
        container.autoregister(MainStore.self, initializer: MainStore.init)
            .inObjectScope(.container)
        
        switch container.purpose {
        case .testing:
            container.autoregister(PKeyValueStore.self, initializer: InMemoryDefaults.init)
                .inObjectScope(.container)
        case .normal:
            container.autoregister(PKeyValueStore.self, initializer: UserDefaults.init)
                .inObjectScope(.container)
        }
    }
    
    private func registerPlugins(container: Container) {
        container.autoregister(GithubPlugin.self, initializer: GithubPlugin.init)
        container.autoregister(RescueTimePlugin.self, initializer: RescueTimePlugin.init)
        container.autoregister(HealthKitPlugin.self, initializer: HealthKitPlugin.init)
        container.autoregister(LocationPlugin.self, initializer: LocationPlugin.init)
    }
    
}
