//  Created by Alexander Skorulis on 7/1/2023.

import ASKCore
import Foundation

public final class FetchContext {
 
    public var result: MetricsResultModel
    public let weekStartDate: Date
    
    public init(result: MetricsResultModel,
                weekStartDate: Date
    ) {
        self.result = result
        self.weekStartDate = weekStartDate
    }
    
    public var lastWeekStart: Date {
        weekStartDate.addingTimeInterval(-86400).startOfWeek
    }
    
    public var weekStart: String {
        return MetricsWeekEntry.dateFormatter.string(from: weekStartDate)
    }
    
    public var currentEntry: MetricsWeekEntry {
        result.entryMatching(weekStartDate) ?? MetricsWeekEntry(week: weekStart)
    }
}
