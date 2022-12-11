//  Created by Alexander Skorulis on 11/12/2022.

import ArgumentParser
import ASKCore
import OctoKit

@main
struct FetchCommand: AsyncParsableCommand {
    
    static let ioc = IOC(purpose: .normal)
    
    private enum CodingKeys : String, CodingKey {
        case github
    }
    
    static var configuration = CommandConfiguration(
        commandName: "MetricFetcher",
        abstract: "Fetch required metrics",
        version: "1.0.0"
    )
    
    @Option(help: "Github API token")
    var github: String
    
    var config: TokenConfiguration {
        TokenConfiguration(github)
    }
    
    var network: GithubHTTPService {
        return Self.ioc.resolve(GithubHTTPService.self)
    }
    
    func run() async throws {
        Self.ioc.resolve(TokensService.self).githubToken = github
        let repos = try await getAllRepositories()
        for repo in repos {
            print("Check \(repo.name)")
            let lines = try await getLines(repo: repo.name!)
        }
    }
    
    func getAllRepositories() async throws -> [Repository] {
        var result = [Repository]()
        var page = 1
        while true {
            let next = try await getRepositories(page: page)
            for repo in next {
                if !repo.isFork {
                    result.append(repo)
                }
            }
            
            page += 1
            if next.count < 100 {
                break
            }
        }
        
        return result
    }
    
    func getRepositories(page: Int) async throws -> [Repository] {
        return try await withCheckedThrowingContinuation { continuation in
            Octokit(config).repositories(page: "\(page)") { response in
              switch response {
              case .success(let user):
                  continuation.resume(with: .success(user))
              case .failure(let error):
                  continuation.resume(with: .failure(error))
              }
            }
        }
    }
    
    func getLines(repo: String) async throws -> RepoLanguageModel {
        let req = GithubRequest.getLanguages(repo: repo)
        return try await network.execute(request: req)
    }

}
