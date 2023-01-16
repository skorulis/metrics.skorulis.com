//  Created by Alexander Skorulis on 16/1/2023.

import Foundation

extension MetricsResultModel {
    
    public func lastRepoMetrics(repo: String, before: Date) -> RepoMetrics? {
        for entry in entries.reversed() {
            if let value = entry.repos[repo], entry.weekStartDate < before {
                return value
            }
        }
        return nil
    }
}
