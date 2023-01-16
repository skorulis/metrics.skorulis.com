//Created by Alexander Skorulis on 8/1/2023.

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
        Button(action: viewModel.fetch) {
            Text("Fetch Data")
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

