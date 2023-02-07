//Created by Alexander Skorulis on 8/1/2023.

import Foundation
import OctoKit
import SwiftUI

public final class GithubPlugin: DataSourcePlugin {
    
    public static let apiToken: APIToken = .init(name: "Github", key: "github")
    public typealias DataType = [String: RepoMetrics]
    public let name: String = "Github"
    public static let keyName: String = "repos"
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
        var hasChanges: Bool = false
        print("Fetching all repositories")
        let repos = try await getAllRepositories(config: config)
        for repo in repos {
            let name = repo.name!
            
            let lastPush = context.lastPush(repo: name)
            if var value = try await repoOutput(network: network, repo: repo, lastFoundPush: lastPush) {
                let lastRepoMetrics = context.lastRepoMetrics(repo: name, before: context.date)
                if context.entries.count > 0 {
                    value.diff = value.diff(from: lastRepoMetrics)
                }
                entry.repos[name] = value
                hasChanges = true
            }
        }
        if hasChanges {
            context.replace(entry: entry)
        }
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
            return nil // No commits
        }
        if let lastFoundPush, lastFoundPush >= lastPush {
            return nil // No changes to this repository
        }
        let name = repo.name!
        print("Fetching lines for \(name)")
        let lines = try await getLines(network: network, repo: name)
        let commitCount = try await network.execute(request: CommitCountRequest(repo: name))
        
        let result = RepoMetrics(languageBytes: lines, lastPush: lastPush, commitCount: commitCount)
        
        return result
    }
    
    public func merge(data: DataType, newData: DataType) -> DataType {
        var output = [String: RepoMetrics]()
        let allRepos = Set(data.keys).union(newData.keys)
        for key in allRepos {
            guard let oldMetrics = data[key] else {
                output[key] = newData[key]
                continue
            }
            guard let newMetrics = newData[key] else {
                output[key] = oldMetrics
                continue
            }
            let diff = merge(oldDiff: oldMetrics.diff, newDiff: newMetrics.diff)
            output[key] = RepoMetrics(
                languageBytes: newMetrics.languageBytes,
                lastPush: newMetrics.lastPush,
                commitCount: oldMetrics.commitCount + newMetrics.commitCount,
                diff: diff
            )
            
        }
        return output
    }
    
    private func merge(oldDiff: RepoChange?, newDiff: RepoChange?) -> RepoChange? {
        guard let oldDiff else {
            return newDiff
        }
        guard let newDiff else {
            return oldDiff
        }
        let allLanguages = Set(oldDiff.languageBytes.keys).union(newDiff.languageBytes.keys)
        var languageBytes: [String: Int] = [:]
        for key in allLanguages {
            languageBytes[key] = (oldDiff.languageBytes[key] ?? 0) + (newDiff.languageBytes[key] ?? 0)
        }
        return RepoChange(
            languageBytes: languageBytes,
            commitCount: oldDiff.commitCount + newDiff.commitCount
        )
    }
    
    public func settingsView(_ viewModel: SettingsViewModel) -> some View {
        VStack {
            TextField(Self.apiToken.name, text: viewModel.tokenBinding(Self.apiToken))
                .textFieldStyle(.roundedBorder)
        }
    }
}

extension FetchContext {
    
    public func lastPush(repo: String) -> Date? {
        for entry in orderedEntries.reversed() {
            if let date = entry.lastPush(repo: repo) {
                return date
            }
        }
        return nil
    }
}
