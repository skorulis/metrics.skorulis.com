//  Created by Alexander Skorulis on 18/12/2022.

import ASKCore
import Foundation
import SwiftCommon

// MARK: - Memory footprint

final class ContentViewModel: ObservableObject {
    
    let network = HTTPService(logger: HTTPLogger(level: .errors))
    
}

// MARK: - Logic

extension ContentViewModel {
    
    func fetchData() async {
        do {
            let req = HTTPJSONRequest<MetricsResultModel>(endpoint: "https://metrics.skorulis.com/data/metrics.json")
            req.decoder.dateDecodingStrategy = .iso8601
            let result = try await network.execute(request: req)
            print(result)
        } catch {
            fatalError("\(error)")
        }
    }
}
