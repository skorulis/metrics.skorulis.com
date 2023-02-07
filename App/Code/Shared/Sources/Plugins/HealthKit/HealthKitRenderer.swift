//  Created by Alexander Skorulis on 27/1/2023.

import Foundation
import SwiftUI

public struct HealthKitRenderer: DataRendererPlugin {
    
    public init() { }
    
    public func canRender(_ entry: MetricsEntry) -> Bool {
        return entry.data(HealthKitPlugin.self) != nil
    }
    
    public func render(_ entry: MetricsEntry) -> some View {
        if let data = entry.data(HealthKitPlugin.self) {
            Text("Steps: \(data.steps)")
        }
    }
    
    public var name: String {
        return "Health"
    }
    
}

