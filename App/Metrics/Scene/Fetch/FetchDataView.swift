//Created by Alexander Skorulis on 8/1/2023.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct FetchDataView {
    @StateObject var viewModel: FetchDataViewModel
}

// MARK: - Rendering

extension FetchDataView: View {
    
    var body: some View {
        Button(action: viewModel.fetch) {
            Text("Fetch Data")
        }
    }
}

// MARK: - Previews

struct FetchDataView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        FetchDataView(viewModel: ioc.resolve())
    }
}

