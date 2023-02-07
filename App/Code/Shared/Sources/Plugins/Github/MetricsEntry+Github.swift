//Created by Alexander Skorulis on 8/1/2023.

import Foundation

extension MetricsEntry {
    
    var repos: [String: RepoMetrics] {
        get {
            return data(GithubPlugin.self) ?? [:]
        }
        set {
            self.setData(GithubPlugin.self, data: newValue)
        }
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
}
