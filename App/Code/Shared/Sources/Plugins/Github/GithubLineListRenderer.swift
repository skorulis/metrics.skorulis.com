//  Created by Alexander Skorulis on 27/1/2023.

import Foundation
import SwiftUI

public struct GithubLineListRenderer: DataRendererPlugin {
    
    public init() { }
    
    public func canRender(_ entry: MetricsEntry) -> Bool {
        return entry.data(GithubPlugin.self) != nil
    }
    
    public func render(_ entry: MetricsEntry) -> some View {
        if let data = entry.data(GithubPlugin.self) {
            GithubView(data: data)
        }
    }
    
    public var name: String {
        return "Github"
    }
    
}
