//  Created by Alexander Skorulis on 11/12/2022.

import ASKCore
import Foundation
import SwinjectAutoregistration
import Shared

final class IOC: IOCService {
    
    override init(purpose: IOCPurpose = .testing) {
        super.init(purpose: purpose)
        _ = ModuleAssembler(container: self.container,
                            modules: [SharedAssembly(), CoreModuleAssembly(purpose: purpose)]
        )
    }
    
}
