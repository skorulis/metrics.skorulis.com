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
    
    static func commitCount(repo: String) -> HTTPJSONRequest<X> {
        let endpoint = "/repos/\(user)/\(repo)/commits"
        var req = HTTPJSONRequest<X>(endpoint: endpoint)
        req.params["per_page"] = "1"
        return req
    }
}

struct X: Codable {}

typealias RepoLanguageModel = [String: Int]

enum KnownLanguage: String {
    case css = "CSS"
    case html = "HTML"
    case javaScript = "JavaScript"
    case shell = "Shell"
    case typescript = "TypeScript"
}
