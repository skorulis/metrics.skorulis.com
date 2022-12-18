//  Created by Alexander Skorulis on 18/12/2022.

import SwiftUI

@main
struct MetricsMacApp: App {
    
    private let ioc = IOC(purpose: .normal)
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ioc.resolve())
                .environment(\.factory, ioc)
        }
    }
}
