//  Created by Alexander Skorulis on 7/1/2023.

import ASKCore
import Foundation

public final class FetchContext {
 
    public private(set) var entries: [Date: MetricsEntry]
    public private(set) var changed: Set<Date> = []
    public let date: Date
    
    public init(entries: [Date: MetricsEntry],
                date: Date
    ) {
        self.entries = entries
        self.date = date
    }

    var currentEntry: MetricsEntry {
        return entry(date: date)
    }
    
    var orderedEntries: [MetricsEntry] {
        return entries.values.sorted { d1, d2 in
            d1.date < d2.date
        }
    }
    
    func replace(entry: MetricsEntry) {
        entries[entry.date] = entry
        changed.insert(entry.date)
    }
    
    func entry(date: Date) -> MetricsEntry {
        return entries[date] ?? MetricsEntry(date: date)
    }
    
}
