//Created by Alexander Skorulis on 8/1/2023.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct SettingsView {
    @StateObject var viewModel: SettingsViewModel
}

// MARK: - Rendering

extension SettingsView: View {
    
    var body: some View {
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
        let ioc = IOC()
        SettingsView(viewModel: ioc.resolve())
    }
}

