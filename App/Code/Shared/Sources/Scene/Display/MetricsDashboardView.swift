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
            groupPicker
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.entries) { entry in
                        entryView(entry)
                    }
                }
            }
        }
    }
    
    private var groupPicker: some View {
        Picker("Grouping", selection:  $viewModel.groupType) {
            ForEach(MetricsDashboardViewModel.GroupType.allCases) { type in
                Text(type.rawValue)
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private func entryView(_ entry: MetricsEntry) -> some View {
        VStack {
            Text(entry.day)
                .typography(.title)
            
            ForEach(viewModel.plugins.sorted, id: \.name) { plugin in
                plugin.maybeRender(entry: entry)
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

