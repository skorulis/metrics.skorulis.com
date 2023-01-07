//  Created by Alexander Skorulis on 7/1/2023.

import Foundation
import SwiftCommon

final class RescueTimePlugin: DataSourcePlugin {
    typealias DataType = RescueTimeDay
    
    let keyName: String = "timeBreakdown"
    
    var dataType: RescueTimeDay.Type { RescueTimeDay.self }
    
    func fetch(context: FetchContext, tokens: TokensService) async throws {
        let service = RescueTimeHTTPService(tokens: tokens)
        let days = try await service.execute(request: RescueTimeRequest.days())
        let weekDays = days.filter { day in
            let date = FetchCommand.dateFormatter.date(from: day.date)!
            let weekDate = date.startOfWeek
            return weekDate == context.weekStartDate
        }
        let previousWeekDays = days.filter { day in
            let date = FetchCommand.dateFormatter.date(from: day.date)!
            let weekDate = date.startOfWeek
            return weekDate == context.lastWeekStart
        }
        
        var entry = context.result.entryMatching(context.weekStartDate) ?? MetricsEntry(week: context.weekStart)
        
        if weekDays.count > 0 {
            entry.setData(self, data: RescueTimeDay.sum(days: weekDays))
        }
        let previousWeek = context.result.entryMatching(context.lastWeekStart)
        
        if previousWeekDays.count == 7, var previousWeek {
            previousWeek.setData(self, data: RescueTimeDay.sum(days: previousWeekDays))
            context.result.replace(entry: previousWeek)
        }
    }
    
}
