//  Created by Alexander Skorulis on 16/1/2023.

import Foundation
import ASKCore
import Swinject
import SwinjectAutoregistration

public final class SharedAssembly: AutoModuleAssembly {
    public static var dependencies: [ModuleAssembly.Type] = []
    
    public init() {}
    
    public func assemble(container: Container) {
        container.autoregister(TokensService.self, initializer: TokensService.init)
            .inObjectScope(.container)
        
        container.autoregister(GithubHTTPService.self, initializer: GithubHTTPService.init)
            .inObjectScope(.container)
        
        container.autoregister(PluginManager.self, initializer: PluginManager.init)
            .inObjectScope(.container)
        
        registerStores(container: container)
        registerViewModels(container: container)
    }
    
    private func registerViewModels(container: Container) {
        container.autoregister(SettingsViewModel.self, initializer: SettingsViewModel.init)
        container.autoregister(FetchDataViewModel.self, initializer: FetchDataViewModel.init)
        container.autoregister(MetricsDashboardViewModel.self, initializer: MetricsDashboardViewModel.init)
    }
    
    private func registerStores(container: Container) {
        container.autoregister(MetricsStore.self, initializer: MetricsStore.init)
        
        switch container.purpose {
        case .testing:
            container.autoregister(PKeyValueStore.self, initializer: InMemoryDefaults.init)
                .inObjectScope(.container)
        case .normal:
            container.autoregister(PKeyValueStore.self, initializer: UserDefaults.init)
                .inObjectScope(.container)
        }
        
    }
    
    
}
