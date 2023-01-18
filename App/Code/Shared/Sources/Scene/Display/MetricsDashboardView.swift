//Created by Alexander Skorulis on 9/1/2023.

import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

public struct MetricsDashboardView {
    @StateObject var viewModel: MetricsDashboardViewModel
    
    public init(viewModel: MetricsDashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

// MARK: - Rendering

extension MetricsDashboardView: View {
    
    public var body: some View {
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
    
    private func entryView(_ entry: MetricsWeekEntry) -> some View {
        VStack {
            Text(entry.week)
                .typography(.title)
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
        let ioc = SharedAssembly().assembled().factory
        MetricsDashboardView(viewModel: ioc.resolve())
    }
}

