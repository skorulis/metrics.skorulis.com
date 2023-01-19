//  Created by Alexander Skorulis on 16/1/2023.

import Foundation

extension FetchContext {
    
    public func lastRepoMetrics(repo: String, before: Date) -> RepoMetrics? {
        for entry in orderedEntries.reversed() {
            if let value = entry.repos[repo], entry.date < before {
                return value
            }
        }
        return nil
    }
}
