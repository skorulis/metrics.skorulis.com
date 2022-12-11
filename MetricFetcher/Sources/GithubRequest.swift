//  Created by Alexander Skorulis on 11/12/2022.

import ASKCore
import Foundation

enum GithubRequest {
    
    static let user = "skorulis"
    
    static func getLanguages(repo: String) -> HTTPJSONRequest<RepoLanguageModel> {
        let endpoint = "/repos/\(user)/\(repo)/languages"
        let req = HTTPJSONRequest<RepoLanguageModel>(endpoint: endpoint)
        
        return req
    }
}

typealias RepoLanguageModel = [String: Int]

enum KnownLanguage: String {
    case css = "CSS"
    case html = "HTML"
    case javaScript = "JavaScript"
    case shell = "Shell"
    case typescript = "TypeScript"
}
