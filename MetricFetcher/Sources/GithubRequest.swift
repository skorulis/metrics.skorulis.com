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

struct CommitCountRequest: HTTPRequest {
    
    typealias ResponseType = Int
    static let regex = try! Regex<(Substring, Substring)>("page=([0-9]*)>; rel=\"last\"")
    
    let endpoint: String
    var method: String { "GET" }
    var body: Data? { nil }
    var headers: [String : String] { ["Accept": "application/json"] }
    var params: [String : String] { ["per_page": "1"] }
    
    init(repo: String) {
        self.endpoint = "/repos/\(GithubRequest.user)/\(repo)/commits"
    }
    
    func decode(data: Data, response: URLResponse) throws -> Int {
        guard let response = response as? HTTPURLResponse,
              let header = response.value(forHTTPHeaderField: "link")
        else {
            throw ErrorType.missingHeader
        }
        
        return try Self.extractPage(link: header)
    }
    
    static func extractPage(link: String) throws -> Int {
        let result = link.firstMatch(of: CommitCountRequest.regex)
        
        guard let value = result?.output.1,
              let number = Int(value)
        else {
            throw ErrorType.missingPage
        }
        return number
    }
    
    enum ErrorType: Error, LocalizedError {
        case missingHeader
        case missingPage
        
        var errorDescription: String? {
            switch self {
            case .missingHeader: return "Could not find link header"
            case .missingPage: return "Could not find last page number"
            }
        }
    }
    
}
