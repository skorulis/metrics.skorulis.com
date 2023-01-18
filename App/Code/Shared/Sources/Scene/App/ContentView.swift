//  Created by Alexander Skorulis on 18/1/2023.

import ASKCore
import Foundation
import SwiftUI

// MARK: - Memory footprint

public struct ContentView {
    @StateObject var viewModel: ContentViewModel
    @Environment(\.factory) private var factory
    
    public init(viewModel: ContentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

// MARK: - Rendering

extension ContentView: View {
    
    public var body: some View {
        if viewModel.isLoggedIn {
            loggedInContent
        } else {
            LoginView(viewModel: factory.resolve())
        }
    }
    
    private var loggedInContent: some View {
        TabView {
            MetricsDashboardView(viewModel: factory.resolve())
                .tabItem {
                    Text("Metrics")
                    Image(systemName: "gauge.low")
                }
            
            FetchDataView(viewModel: factory.resolve())
                .tabItem {
                    Text("Fetch")
                    Image(systemName: "icloud.and.arrow.down")
                }
            SettingsView(viewModel: factory.resolve())
                .tabItem {
                    Text("Settings")
                    Image(systemName: "gearshape.circle.fill")
                }
        }
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = SharedAssembly().assembled().factory
        ContentView(viewModel: ioc.resolve())
    }
}

