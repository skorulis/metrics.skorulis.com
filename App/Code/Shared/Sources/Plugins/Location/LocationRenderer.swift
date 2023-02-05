//  Created by Alexander Skorulis on 5/2/2023.

import Foundation
import SwiftUI

public struct LocationRenderer: DataRendererPlugin {
    
    public init() { }
    
    public func canRender(_ entry: MetricsEntry) -> Bool {
        return entry.data(LocationPlugin()) != nil
    }
    
    public func render(_ entry: MetricsEntry) -> some View {
        return HStack {
            
        }
    }
    
    public var name: String {
        return "Location"
    }
}
