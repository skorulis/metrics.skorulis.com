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
        
        container.autoregister(RescueTimeHTTPService.self, initializer: RescueTimeHTTPService.init)
            .inObjectScope(.container)
        
        container.autoregister(PluginManager.self, initializer: PluginManager.init)
            .inObjectScope(.container)
        
        container.autoregister(FetchService.self, initializer: FetchService.init)
            .inObjectScope(.container)
    }
    
    private func registerViewModels() {
        container.autoregister(SettingsViewModel.self, initializer: SettingsViewModel.init)
    }
    
    private func registerStores() {
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
