//  Created by Alexander Skorulis on 18/12/2022.

import ASKCore
import Foundation
import Swinject
import SwinjectAutoregistration

public final class IOC: IOCService {

    override init(purpose: IOCPurpose = .testing) {
        super.init(purpose: purpose)
        
        container.autoregister(ContentViewModel.self, initializer: ContentViewModel.init)
    }
    
}

