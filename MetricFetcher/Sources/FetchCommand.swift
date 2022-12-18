//  Created by Alexander Skorulis on 11/12/2022.

import ArgumentParser
import ASKCore
import Foundation
import OctoKit
import SwiftCommon

@main
struct FetchCommand: AsyncParsableCommand {
    
    static let ioc = IOC(purpose: .normal)
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    private enum CodingKeys : String, CodingKey {
        case github, output, rescue
    }
    
    static var configuration = CommandConfiguration(
        commandName: "MetricFetcher",
        abstract: "Fetch required metrics",
        version: "1.0.0"
    )
    
    @Option(help: "Github API token")
    var github: String
    
    @Option(help: "RescueTime API token")
    var rescue: String
    
    @Option(help: "Where to store the result")
    var output: String
    
    var outputURL: URL { URL(fileURLWithPath: output) }
    
    var config: TokenConfiguration {
        TokenConfiguration(github)
    }
    
    var network: GithubHTTPService {
        return Self.ioc.resolve(GithubHTTPService.self)
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
    
    func run() async throws {
        Self.ioc.resolve(TokensService.self).githubToken = github
        Self.ioc.resolve(TokensService.self).rescueTimeToken = rescue
        
        var result = try loadExisting()
        let weekStartDate = Date().startOfWeek
        let weekStart = MetricsEntry.weekStart
        var entry = result.entryMatching(weekStart) ?? MetricsEntry(week: weekStart)
        
        let repos = try await getAllRepositories()
        for repo in repos {
            let name = repo.name!
            let lastPush = result.lastPush(repo: name)
            if var value = try await repoOutput(repo: repo, lastFoundPush: lastPush) {
                let lastRepoMetrics = result.lastRepoMetrics(repo: name, before: weekStartDate)
                if result.entries.count > 0 {
                    value.diff = value.diff(from: lastRepoMetrics)
                }
                entry.repos[name] = value
            }
        }
        
        if let previous = result.entries.last, previous.week == entry.week {
            result.entries[result.entries.count - 1] = entry
        } else {
            result.entries.append(entry)
        }
        
        let days = try await Self.ioc.resolve(RescueTimeHTTPService.self).execute(request: RescueTimeRequest.days())
        
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
