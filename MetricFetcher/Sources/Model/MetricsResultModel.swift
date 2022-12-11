//  Created by Alexander Skorulis on 11/12/2022.

import Foundation

struct MetricsResultModel: Codable {
    var entries: [MetricsEntry]
    
    func lastPush(repo: String) -> Date? {
        for entry in entries.reversed() {
            if let date = entry.lastPush(repo: repo) {
                return date
            }
        }
        return nil
    }
    
    func entryMatching(_ week: String) -> MetricsEntry? {
        return entries.first(where: {$0.week == week})
    }
}

struct MetricsEntry: Codable {
    
    let week: String
    var repos: [String: RepoMetrics]
    
    init(week: String) {
        self.week = week
        repos = [:]
    }
    
    static var weekStart: String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let weekStart = Date().startOfMonth
        
        return df.string(from: weekStart)
    }
    
    func lastPush(repo: String) -> Date? {
        return repos[repo]?.lastPush
    }
    
}

struct RepoMetrics: Codable {
    let languageBytes: [String: Int]
    let lastPush: Date
}
