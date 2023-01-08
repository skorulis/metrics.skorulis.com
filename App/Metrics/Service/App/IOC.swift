//  Created by Alexander Skorulis on 11/12/2022.

import ASKCore
import Foundation
import SwinjectAutoregistration

final class IOC: IOCService {
    
    override init(purpose: IOCPurpose = .testing) {
        super.init(purpose: purpose)
        registerViewModels()
        registerStores()
        
        container.autoregister(TokensService.self, initializer: TokensService.init)
            .inObjectScope(.container)
        
        container.autoregister(GithubHTTPService.self, initializer: GithubHTTPService.init)
            .inObjectScope(.container)
        
        container.autoregister(PluginManager.self, initializer: PluginManager.init)
            .inObjectScope(.container)
    }
    
    private func registerViewModels() {
        container.autoregister(SettingsViewModel.self, initializer: SettingsViewModel.init)
        container.autoregister(FetchDataViewModel.self, initializer: FetchDataViewModel.init)
    }
    
    private func registerStores() {
        container.autoregister(MetricsStore.self, initializer: MetricsStore.init)
        
        switch purpose {
        case .testing:
            container.autoregister(PKeyValueStore.self, initializer: InMemoryDefaults.init)
                .inObjectScope(.container)
        case .normal:
            container.autoregister(PKeyValueStore.self, initializer: UserDefaults.init)
                .inObjectScope(.container)
        }
        
    }
}
