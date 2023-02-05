//  Created by Alexander Skorulis on 27/1/2023.

import Foundation
import SwiftUI

public struct GithubLineListRenderer: DataRendererPlugin {
    
    public init() { }
    
    public func canRender(_ entry: MetricsEntry) -> Bool {
        return entry.data(GithubPlugin()) != nil
    }
    
    public func render(_ entry: MetricsEntry) -> some View {
        if let data = entry.data(GithubPlugin()) {
            GithubView(data: data)
        }
    }
    
    public var name: String {
        return "Github"
    }
    
}
