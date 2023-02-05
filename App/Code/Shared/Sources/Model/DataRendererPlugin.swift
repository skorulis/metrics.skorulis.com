//  Created by Alexander Skorulis on 27/1/2023.

import Foundation
import SwiftUI

public protocol DataRendererPlugin {
    associatedtype BodyType: View
    
    var name: String { get }
    
    func canRender(_ entry: MetricsEntry) -> Bool
    
    @ViewBuilder
    func render(_ entry: MetricsEntry) -> Self.BodyType
}

public extension DataRendererPlugin {
    func erasedRender(_ entry: MetricsEntry) -> AnyView? {
        if !canRender(entry) {
            return nil
        }
        let view = render(entry)
        return AnyView(view)
    }
}
