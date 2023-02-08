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
        PageTemplate(nav: nav, content: content)
    }
    
    private func nav() -> some View {
        NavBar(mid: NavBarItem.title("Fetch"))
    }
    
    private func content() -> some View {
        VStack {
            
            ForEach(viewModel.pluginList, id: \.name) { plugin in
                row(plugin)
            }
            
            Button(action: viewModel.fetch) {
                Text("Fetch Data")
            }
            .buttonStyle(ASKButtonStyle())
        }
    }
    
    private func row(_ plugin: any DataSourcePlugin) -> some View {
        let status = viewModel.fetchStatus.status(plugin: plugin)
        return AlertCell(
            title: plugin.name,
            subtitle: status.fullTitle,
            image: status.icon
        )
    }
}

// MARK: - Previews

struct FetchDataView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = SharedAssembly().assembled().factory
        FetchDataView(viewModel: ioc.resolve())
    }
}

