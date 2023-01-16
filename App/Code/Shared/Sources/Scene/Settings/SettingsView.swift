//Created by Alexander Skorulis on 8/1/2023.

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
        VStack {
            ForEach(viewModel.tokenKeys) { token in
                TextField(token.name, text: viewModel.tokenBinding(token))
            }
        }
    }
}

// MARK: - Previews

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = SharedAssembly().assembled().factory
        SettingsView(viewModel: ioc.resolve())
    }
}

