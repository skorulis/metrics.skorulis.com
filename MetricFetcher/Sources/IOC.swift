//  Created by Alexander Skorulis on 11/12/2022.

import ASKCore
import Foundation
import SwinjectAutoregistration

final class IOC: IOCService {
    
    override init(purpose: IOCPurpose) {
        super.init(purpose: purpose)
        
        container.autoregister(TokensService.self, initializer: TokensService.init)
            .inObjectScope(.container)
        
        container.autoregister(GithubHTTPService.self, initializer: GithubHTTPService.init)
            .inObjectScope(.container)
        
        container.autoregister(RescueTimeHTTPService.self, initializer: RescueTimeHTTPService.init)
            .inObjectScope(.container)
        
    }
}
