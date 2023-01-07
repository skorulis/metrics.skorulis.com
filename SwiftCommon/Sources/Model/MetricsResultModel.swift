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
    
    public func entryMatching(_ week: Date) -> MetricsEntry? {
        return entries.first(where: {$0.weekStartDate == week})
    }
    
    public func lastRepoMetrics(repo: String, before: Date) -> RepoMetrics? {
        for entry in entries.reversed() {
            if let value = entry.repos[repo], entry.weekStartDate < before {
                return value
            }
        }
        return nil
    }
    
    
    public mutating func replace(entry: MetricsEntry) {
        if let index = entries.firstIndex(where: {$0.week == entry.week}) {
            self.entries[index] = entry
        } else {
            self.entries.append(entry)
        }
    }
}

public struct MetricsEntry: Codable {
    
    public let week: String
    public var repos: [String: RepoMetrics]
    public func data<T: DataSourcePlugin>(_ plugin: T) -> T.DataType? {
        return pluginData[plugin.keyName] as? T.DataType
    }
    public mutating func setData<T: DataSourcePlugin>(_ plugin: T, data: T.DataType) {
        pluginData[plugin.keyName] = data
    }
    
    public var pluginData: [String: any Codable]
    
    public init(week: String) {
        self.week = week
        repos = [:]
        pluginData = [:]
    }
    
    var weekStartDate: Date {
        return Self.dateFormatter.date(from: week)!
    }
    
    static let dateFormatter: DateFormatter = {
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
    
    public var totalDiff: RepoChange {
        let commits = repos.values.reduce(0) { partialResult, metrics in
            return partialResult + (metrics.diff?.commitCount ?? 0)
        }
        var languageCounts: [String: Int] = [:]
        for repo in repos.values {
            guard let diff = repo.diff else { continue }
            diff.languageBytes.forEach { key, value in
                languageCounts[key] = (languageCounts[key] ?? 0) + value
            }
        }
        
        return RepoChange(languageBytes: languageCounts, commitCount: commits)
    }
    
    public init(from decoder: Decoder) throws {
        let plugins = decoder.userInfo[.init(rawValue: "plugins")!] as! [String: any DataSourcePlugin]
        let container = try decoder.container(keyedBy: GenericCodingKeys.self)
        self.week = try container.decode(String.self, forKey: "week")
        self.repos = try container.decode([String: RepoMetrics].self, forKey: "repos")
        
        pluginData = [:]
        for (key, value) in plugins {
            if let data = try container.decodeIfPresent(value.dataType, forKey: .init(stringLiteral: key)) {
                pluginData[key] = data
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        let plugins = encoder.userInfo[.init(rawValue: "plugins")!] as! [String: any DataSourcePlugin]
        var container = encoder.container(keyedBy: GenericCodingKeys.self)
        try container.encode(week, forKey: "week")
        try container.encode(repos, forKey: "repos")
        
        for (key, value) in pluginData {
            let handler = plugins[key]!
            try container.encode(value, forKey: .init(stringLiteral: key))
        }
    }
    
}

public struct RepoMetrics: Codable {
    public let languageBytes: [String: Int]
    public let lastPush: Date
    public let commitCount: Int
    /// Metrics change in this week
    public var diff: RepoChange?
    
    public init(languageBytes: [String: Int],
                lastPush: Date,
                commitCount: Int,
                diff: RepoChange? = nil
    ) {
        self.languageBytes = languageBytes
        self.lastPush = lastPush
        self.commitCount = commitCount
        self.diff = diff
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
    
    public init(languageBytes: [String: Int], commitCount: Int) {
        self.languageBytes = languageBytes
        self.commitCount = commitCount
    }
}

struct GenericCodingKeys: CodingKey, ExpressibleByStringLiteral {
    // MARK: CodingKey
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { return nil }

    // MARK: ExpressibleByStringLiteral
    typealias StringLiteralType = String
    init(stringLiteral: StringLiteralType) { self.stringValue = stringLiteral }
}
