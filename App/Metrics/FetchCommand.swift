//  Created by Alexander Skorulis on 11/12/2022.

import ASKCore
import Foundation
/*
struct FetchCommand {
    
    static let ioc = IOC(purpose: .normal)
    
    
    var network: GithubHTTPService {
        return Self.ioc.resolve(GithubHTTPService.self)
    }
    
    
    
    func run() async throws {
        let plugins = Self.ioc.resolve(PluginManager.self)
        plugins.register(plugin: RescueTimePlugin())
            
        Self.ioc.resolve(TokensService.self).githubToken = github
        Self.ioc.resolve(TokensService.self).rescueTimeToken = rescue
        
        var result = try loadExisting()
        let context = FetchContext(result: result, weekStartDate: Date().startOfWeek)
        let weekStart = MetricsEntry.weekStart
        var entry = result.entryMatching(context.weekStartDate) ?? MetricsEntry(week: weekStart)
        
        
        let repos = try await getAllRepositories()
        for repo in repos {
            let name = repo.name!
            let lastPush = result.lastPush(repo: name)
            if var value = try await repoOutput(repo: repo, lastFoundPush: lastPush) {
                let lastRepoMetrics = result.lastRepoMetrics(repo: name, before: context.weekStartDate)
                if result.entries.count > 0 {
                    value.diff = value.diff(from: lastRepoMetrics)
                }
                entry.repos[name] = value
            }
        }
        
        result.replace(entry: entry)
        
        let outputData = try encoder.encode(result)
        try outputData.write(to: outputURL, options: [.atomic])
    }
    
    func loadExisting() throws -> MetricsResultModel {
        if FileManager.default.fileExists(atPath: output) {
            let data = try Data(contentsOf: outputURL)
            return try decoder.decode(MetricsResultModel.self, from: data)
        } else {
            return MetricsResultModel(entries: [])
        }
    }
    
    func getRescueTime() async throws -> [RescueTimeDay] {
        return try await Self.ioc.resolve(RescueTimeHTTPService.self).execute(request: RescueTimeRequest.days())
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
    
    func repoOutput(repo: Repository, lastFoundPush: Date?) async throws -> RepoMetrics? {
        guard let lastPush = repo.lastPush else {
            return nil
        }
        if let lastFoundPush, lastFoundPush >= lastPush {
            return nil // No changes to this repository
        }
        let name = repo.name!
        let lines = try await getLines(repo: name)
        let commitCount = try await network.execute(request: CommitCountRequest(repo: name))
        
        let result = RepoMetrics(languageBytes: lines, lastPush: lastPush, commitCount: commitCount)
        
        return result
    }

}
*/
