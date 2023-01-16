//Created by Alexander Skorulis on 8/1/2023.

import Foundation
import OctoKit
import SwiftUI

public final class GithubPlugin: DataSourcePlugin {
    
    public static let apiToken: APIToken = .init(name: "Github", key: "github")
    public typealias DataType = [String: RepoMetrics]
    public let name: String = "Github"
    public let keyName: String = "repos"
    public var dataType: [String: RepoMetrics].Type { [String: RepoMetrics].self }
    public var tokenKeys: [APIToken] {
        return [Self.apiToken]
    }
    
    public init() {}
    
    public func fetch(context: FetchContext, tokens: [String: String]) async throws {
        let token = tokens[Self.apiToken.key]!
        let config = TokenConfiguration(token)
        let network = GithubHTTPService(token: token)
        
        var entry = context.currentEntry
        
        let repos = try await getAllRepositories(config: config)
        for repo in repos {
            let name = repo.name!
            let lastPush = context.result.lastPush(repo: name)
            if var value = try await repoOutput(network: network, repo: repo, lastFoundPush: lastPush) {
                let lastRepoMetrics = context.result.lastRepoMetrics(repo: name, before: context.weekStartDate)
                if context.result.entries.count > 0 {
                    value.diff = value.diff(from: lastRepoMetrics)
                }
                entry.repos[name] = value
            }
        }
        
        context.result.replace(entry: entry)
    }
    
    func getAllRepositories(config: TokenConfiguration) async throws -> [Repository] {
        var result = [Repository]()
        var page = 1
        while true {
            let next = try await getRepositories(config: config, page: page)
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
    
    func getRepositories(config: TokenConfiguration, page: Int) async throws -> [Repository] {
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
    
    func getLines(network: GithubHTTPService, repo: String) async throws -> RepoLanguageModel {
        let req = GithubRequest.getLanguages(repo: repo)
        return try await network.execute(request: req)
    }
    
    func repoOutput(network: GithubHTTPService, repo: Repository, lastFoundPush: Date?) async throws -> RepoMetrics? {
        guard let lastPush = repo.lastPush else {
            return nil
        }
        if let lastFoundPush, lastFoundPush >= lastPush {
            return nil // No changes to this repository
        }
        let name = repo.name!
        let lines = try await getLines(network: network, repo: name)
        let commitCount = try await network.execute(request: CommitCountRequest(repo: name))
        
        let result = RepoMetrics(languageBytes: lines, lastPush: lastPush, commitCount: commitCount)
        
        return result
    }
    
    public func render(_ entry: MetricsEntry) -> AnyView? {
        guard let data: DataType = entry.data(self) else {
            return nil
        }
        return AnyView(GithubView(data: data))
    }
}
