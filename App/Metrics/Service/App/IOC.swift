//  Created by Alexander Skorulis on 11/12/2022.

import ASKCore
import Foundation
import SwinjectAutoregistration
import Shared

final class IOC: IOCService {
    
    override init(purpose: IOCPurpose = .testing) {
        super.init(purpose: purpose)
        _ = ModuleAssembler(container: self.container, moduleType: SharedAssembly.self)
        registerViewModels()
    }
    
    private func registerViewModels() {
        container.autoregister(SettingsViewModel.self, initializer: SettingsViewModel.init)
        container.autoregister(FetchDataViewModel.self, initializer: FetchDataViewModel.init)
        container.autoregister(MetricsDashboardViewModel.self, initializer: MetricsDashboardViewModel.init)
    }
    
}
