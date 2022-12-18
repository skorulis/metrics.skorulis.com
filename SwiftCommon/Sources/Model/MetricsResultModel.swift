//  Created by Alexander Skorulis on 11/12/2022.

import Foundation

public struct MetricsResultModel: Codable {
    public var entries: [MetricsEntry]
    
    public init(entries: [MetricsEntry]) {
        self.entries = entries
    }
    
    public func lastPush(repo: String) -> Date? {
        for entry in entries.reversed() {
            if let date = entry.lastPush(repo: repo) {
                return date
            }
        }
        return nil
    }
    
    public func entryMatching(_ week: String) -> MetricsEntry? {
        return entries.first(where: {$0.week == week})
    }
    
    public func lastRepoMetrics(repo: String, before: Date) -> RepoMetrics? {
        for entry in entries.reversed() {
            if let value = entry.repos[repo], entry.weekStartDate < before {
                return value
            }
        }
        return nil
    }
    
}

public struct MetricsEntry: Codable {
    
    public let week: String
    public var repos: [String: RepoMetrics]
    
    public init(week: String) {
        self.week = week
        repos = [:]
    }
    
    var weekStartDate: Date {
        return Self.dateFormatter.date(from: week)!
    }
    
    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    public static var weekStart: String {
        let weekStart = Date().startOfWeek
        return dateFormatter.string(from: weekStart)
    }
    
    public func lastPush(repo: String) -> Date? {
        return repos[repo]?.lastPush
    }
    
}

public struct RepoMetrics: Codable {
    public let languageBytes: [String: Int]
    public let lastPush: Date
    public let commitCount: Int
    /// Metrics change in this week
    public var diff: RepoChange?
    
    public init(languageBytes: [String: Int], lastPush: Date, commitCount: Int) {
        self.languageBytes = languageBytes
        self.lastPush = lastPush
        self.commitCount = commitCount
    }
    
    public func diff(from: RepoMetrics?) -> RepoChange {
        let commitChange = commitCount - (from?.commitCount ?? 0)
        let languageChange = languageBytes.map { (key, value) in
            let change = value - (from?.languageBytes[key] ?? 0)
            return (key, change)
        }
        let languageDict = Dictionary(uniqueKeysWithValues: languageChange)
        return RepoChange(languageBytes: languageDict, commitCount: commitChange)
    }
}

public struct RepoChange: Codable {
    public let languageBytes: [String: Int]
    public let commitCount: Int
}

fileprivate extension Date {
    /// First monday of the week
    var startOfWeek: Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: calendar.startOfDay(for: self)))!
    }
}
