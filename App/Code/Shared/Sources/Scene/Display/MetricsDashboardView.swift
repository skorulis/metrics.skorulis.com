//Created by Alexander Skorulis on 9/1/2023.

import ASKDesignSystem
import Foundation
import Introspect
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
        GeometryReader { proxy in
            VStack {
                groupPicker
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(viewModel.entries) { entry in
                            entryView(entry, pageWidth: proxy.size.width)
                                .padding(.horizontal, 8)
                                .frame(width: proxy.size.width)
                        }
                    }
                }
                .introspectScrollView { uiScrollView in
                    uiScrollView.isPagingEnabled = true
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
    
    private func entryView(_ entry: MetricsEntry, pageWidth: CGFloat) -> some View {
        VStack(spacing: 12) {
            Text(viewModel.title(entry: entry))
                .typography(.title)
            
            ForEach(viewModel.plugins.renderers, id: \.name) { plugin in
                if let view = plugin.erasedRender(entry) {
                    view
                        .frame(width: pageWidth - 40)
                        .modifier(MetricsPanelModifier(title: plugin.name))
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

