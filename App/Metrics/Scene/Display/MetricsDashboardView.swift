//Created by Alexander Skorulis on 9/1/2023.

import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct MetricsDashboardView {
    @StateObject var viewModel: MetricsDashboardViewModel
}

// MARK: - Rendering

extension MetricsDashboardView: View {
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.entries) { entry in
                        entryView(entry)
                    }
                }
            }
        }
    }
    
    private func entryView(_ entry: MetricsEntry) -> some View {
        VStack {
            Text(entry.week)
                .typography(.headline)
            ForEach(viewModel.plugins.sorted, id: \.name) { plugin in
                if let view = plugin.render(entry) {
                    view
                }
            }
            Spacer()
        }
    }
    
    
}

// MARK: - Previews

struct MetricsDashboardView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        MetricsDashboardView(viewModel: ioc.resolve())
    }
}

