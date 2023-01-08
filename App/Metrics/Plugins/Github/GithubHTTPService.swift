//  Created by Alexander Skorulis on 11/12/2022.

import ASKCore
import Foundation

final class GithubHTTPService: HTTPService {
    
    private let tokens: TokensService
    
    init(tokens: TokensService) {
        self.tokens = tokens
        super.init(
            baseURL: "https://api.github.com",
            logger: HTTPLogger(level: .errors)
        )
    }
    
    override func modify(request: inout URLRequest) throws {
        guard let githubToken = tokens.value(token: GithubPlugin.apiToken) else {
            fatalError("Missing github token")
        }
        request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        request.addValue(
            "Bearer \(githubToken)",
            forHTTPHeaderField: "Authorization"
        )
    }
    
}
