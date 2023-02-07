//  Created by Alexander Skorulis on 5/2/2023.

import Foundation
import SwiftUI

public struct LocationRenderer: DataRendererPlugin {
    
    public init() { }
    
    public func canRender(_ entry: MetricsEntry) -> Bool {
        return entry.data(LocationPlugin.self) != nil
    }
    
    public func render(_ entry: MetricsEntry) -> some View {
        let dist = entry.data(LocationPlugin.self)!.maxDistance / 1000
        let distanceText = NumberFormatter.decimalFormatter.string(from: dist)
        return VStack {
            Text("Distance from home: \(distanceText) KM")
        }
    }
    
    public var name: String {
        return "Location"
    }
    
}
