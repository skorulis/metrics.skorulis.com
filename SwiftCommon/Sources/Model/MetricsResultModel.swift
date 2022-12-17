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
}

public struct MetricsEntry: Codable {
    
    public let week: String
    public var repos: [String: RepoMetrics]
    
    public init(week: String) {
        self.week = week
        repos = [:]
    }
    
    public static var weekStart: String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let weekStart = Date().startOfWeek
        
        return df.string(from: weekStart)
    }
    
    public func lastPush(repo: String) -> Date? {
        return repos[repo]?.lastPush
    }
    
}

public struct RepoMetrics: Codable {
    public let languageBytes: [String: Int]
    public let lastPush: Date
    public let commitCount: Int
    
    public init(languageBytes: [String: Int], lastPush: Date, commitCount: Int) {
        self.languageBytes = languageBytes
        self.lastPush = lastPush
        self.commitCount = commitCount
    }
}

fileprivate extension Date {
    /// First monday of the week
    var startOfWeek: Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: calendar.startOfDay(for: self)))!
    }
}
