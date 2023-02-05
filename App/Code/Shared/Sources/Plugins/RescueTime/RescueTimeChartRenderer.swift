//  Created by Alexander Skorulis on 27/1/2023.

import Foundation
import SwiftUI

public struct RescueTimeChartRenderer: DataRendererPlugin {
    
    public init() { }
    
    public func canRender(_ entry: MetricsEntry) -> Bool {
        return entry.data(RescueTimePlugin()) != nil
    }
    
    public func render(_ entry: MetricsEntry) -> some View {
        if let data = entry.data(RescueTimePlugin()) {
            RescueTimeView(data: data)
        }
    }
    
    public var name: String {
        return "RescueTime"
    }
    
}
