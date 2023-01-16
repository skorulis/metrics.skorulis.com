//Created by Alexander Skorulis on 8/1/2023.

import Foundation

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
