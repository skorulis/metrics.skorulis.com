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
        decoder.userInfo[.pluginsKey] = Self.ioc.resolve(PluginManager.self).plugins
        return decoder
    }
    
    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.userInfo[.pluginsKey] = Self.ioc.resolve(PluginManager.self).plugins
        return encoder
    }
    
    func run() async throws {
        let plugins = Self.ioc.resolve(PluginManager.self)
        plugins.register(plugin: RescueTimePlugin())
            
        
        Self.ioc.resolve(TokensService.self).githubToken = github
        Self.ioc.resolve(TokensService.self).rescueTimeToken = rescue
        
        var result = try loadExisting()
        let weekStartDate = Date().startOfWeek
        let weekStart = MetricsEntry.weekStart
        let lastWeekStart = weekStartDate.addingTimeInterval(-86400).startOfWeek
        var entry = result.entryMatching(weekStartDate) ?? MetricsEntry(week: weekStart)
        let previousWeek = result.entryMatching(lastWeekStart)
        
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
        
        let days = try await Self.ioc.resolve(RescueTimeHTTPService.self).execute(request: RescueTimeRequest.days())
        let weekDays = days.filter { day in
            let date = FetchCommand.dateFormatter.date(from: day.date)!
            let weekDate = date.startOfWeek
            return weekDate == weekStartDate
        }
        let previousWeekDays = days.filter { day in
            let date = FetchCommand.dateFormatter.date(from: day.date)!
            let weekDate = date.startOfWeek
            return weekDate == lastWeekStart
        }
        if weekDays.count > 0 {
            entry.timeBreakdown = RescueTimeDay.sum(days: weekDays)
        }
        
        if previousWeekDays.count == 7, var previousWeek {
            previousWeek.timeBreakdown = RescueTimeDay.sum(days: previousWeekDays)
            result.replace(entry: previousWeek)
        }
        
        result.replace(entry: entry)
        
        print(previousWeekDays.count)
        
        print(weekDays)
        
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
