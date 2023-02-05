//Created by Alexander Skorulis on 8/1/2023.

import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

public struct SettingsView {
    @StateObject var viewModel: SettingsViewModel
    
    public init(viewModel: SettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

// MARK: - Rendering

extension SettingsView: View {
    
    public var body: some View {
        PageTemplate(nav: nav, content: content)
    }
    
    private func nav() -> some View {
        NavBar(
            mid: .title("Settings"),
            right: .iconButton(Image(systemName: "plus.circle.fill"), viewModel.startAddPlugin)
            )
    }
    
    private func content() -> some View {
        VStack(spacing: 16) {
            pluginViews
        }
        .padding(.horizontal, 16)
    }
    
    private var pluginViews: some View {
        ForEach(viewModel.plugins.sorted, id: \.name) { plugin in
            wrappedView(plugin)
        }
    }
    
    private func wrappedView(_ plugin: any DataSourcePlugin) -> some View {
        plugin.anySettingsView(viewModel)
            .modifier(MetricsPanelModifier(title: plugin.name))
    }
}

// MARK: - Previews

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = SharedAssembly().assembled().factory
        ioc.resolve(PluginManager.self).register(plugin: GithubPlugin())
        return SettingsView(viewModel: ioc.resolve())
    }
}

