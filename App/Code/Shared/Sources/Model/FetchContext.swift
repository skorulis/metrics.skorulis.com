//  Created by Alexander Skorulis on 7/1/2023.

import ASKCore
import Foundation

public final class FetchContext {
 
    public var entries: [Date: MetricsEntry]
    public let date: Date
    
    public init(entries: [Date: MetricsEntry],
                date: Date
    ) {
        self.entries = entries
        self.date = date
    }

    var currentEntry: MetricsEntry {
        return entries[date] ?? MetricsEntry(date: date)
    }
    
    var orderedEntries: [MetricsEntry] {
        return entries.values.sorted { d1, d2 in
            d1.date < d2.date
        }
    }
    
    func replace(entry: MetricsEntry) {
        entries[entry.date] = entry
    }
    
    func entry(date: Date) -> MetricsEntry {
        return entries[date] ?? MetricsEntry(date: date)
    }
    
}
