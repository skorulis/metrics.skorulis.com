//  Created by Alexander Skorulis on 11/12/2022.

import ASKCore
import Foundation

final class GithubHTTPService: HTTPService {
    
    private let token: String
    
    init(token: String) {
        self.token = token
        super.init(
            baseURL: "https://api.github.com",
            logger: HTTPLogger(level: .errors)
        )
    }
    
    override func modify(request: inout URLRequest) throws {
        request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        request.addValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )
    }
    
}
