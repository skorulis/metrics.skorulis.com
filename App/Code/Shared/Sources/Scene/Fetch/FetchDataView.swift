//Created by Alexander Skorulis on 8/1/2023.

import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

public struct FetchDataView {
    @StateObject var viewModel: FetchDataViewModel
    
    public init(viewModel: FetchDataViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

// MARK: - Rendering

extension FetchDataView: View {
    
    public var body: some View {
        VStack {
            Button(action: viewModel.fetch) {
                Text("Fetch Data")
            }
            .buttonStyle(ASKButtonStyle())
            ForEach(viewModel.pluginList, id: \.name) { plugin in
                row(plugin)
            }
        }
    }
    
    private func row(_ plugin: any DataSourcePlugin) -> some View {
        let status = viewModel.fetchStatus.status(plugin: plugin)
        return HStack {
            VStack(alignment: .leading) {
                Text(plugin.name)
                    .typography(.title)
                Text(status.fullTitle)
            }
            Spacer()
            status.icon
                .resizable()
                .frame(width: 24, height: 24)
            
        }
    }
}

// MARK: - Previews

struct FetchDataView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = SharedAssembly().assembled().factory
        FetchDataView(viewModel: ioc.resolve())
    }
}

