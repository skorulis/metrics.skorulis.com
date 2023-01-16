//Created by Alexander Skorulis on 14/1/2023.

import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct MetricsPanel<Content: View> {
    let title: String
    let content: () -> Content
    
    
}

// MARK: - Rendering

extension MetricsPanel: View {
    
    var body: some View {
        VStack {
            Text(title)
                .typography(.title)
        }
    }
}

// MARK: - Previews

struct MetricsPanel_Previews: PreviewProvider {
    
    static var previews: some View {
        MetricsPanel(title: "Example") {
            Text("TEST")
        }
    }
}

