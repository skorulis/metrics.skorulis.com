//Created by Alexander Skorulis on 14/1/2023.

import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct MetricsPanel<Content: View> {
    let title: String
    let borderColor: Color = .ask.secondary
    let content: () -> Content
}

// MARK: - Rendering

extension MetricsPanel: View {
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            titleOverlay
            VStack(alignment: .leading) {
                content()
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
        
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor, lineWidth: 4)
        )
    }
    
    private var titleOverlay: some View {
        Text(title)
            .typography(.largeBody)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.white.padding(.vertical,10))
            .offset(x: 12, y: -14)
    }
    
}

struct MetricsPanelModifier: ViewModifier {
    let title: String
    
    func body(content: Content) -> some View {
        MetricsPanel(title: title) {
            content
        }
    }
}

// MARK: - Previews

struct MetricsPanel_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack(spacing: 12) {
            MetricsPanel(title: "Example") {
                Text("Some long content")
            }
            MetricsPanel(title: "Example") {
                Text("Some even longer contenr that wraps onto multiple lines")
            }
        }
        .padding(.horizontal, 8)
        
    }
}

