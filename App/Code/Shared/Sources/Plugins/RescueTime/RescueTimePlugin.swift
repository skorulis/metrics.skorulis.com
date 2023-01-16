//  Created by Alexander Skorulis on 7/1/2023.

import Foundation
import SwiftUI

public final class RescueTimePlugin: DataSourcePlugin {
    public typealias DataType = RescueTimeDay
    
    static let rescueTimeToken = APIToken(name: "Rescue time token", key: "rescue_time")
    
    public let name: String = "Rescue Time"
    public let keyName: String = "timeBreakdown"
    public var dataType: RescueTimeDay.Type { RescueTimeDay.self }
    public var tokenKeys: [APIToken] {
        return [Self.rescueTimeToken]
    }
    
    public init() {}
    
    public func fetch(context: FetchContext, tokens: [String: String]) async throws {
        let service = RescueTimeHTTPService(token: tokens[Self.rescueTimeToken.key]!)
        let days = try await service.execute(request: RescueTimeRequest.days())
        let weekDays = days.filter { day in
            let date = MetricsEntry.dateFormatter.date(from: day.date)!
            let weekDate = date.startOfWeek
            return weekDate == context.weekStartDate
        }
        let previousWeekDays = days.filter { day in
            let date = MetricsEntry.dateFormatter.date(from: day.date)!
            let weekDate = date.startOfWeek
            return weekDate == context.lastWeekStart
        }
        
        var entry = context.currentEntry
        
        if weekDays.count > 0 {
            entry.setData(self, data: RescueTimeDay.sum(days: weekDays))
            context.result.replace(entry: entry)
        }
        let previousWeek = context.result.entryMatching(context.lastWeekStart)
        
        if previousWeekDays.count == 7, var previousWeek {
            previousWeek.setData(self, data: RescueTimeDay.sum(days: previousWeekDays))
            context.result.replace(entry: previousWeek)
        }
    }
    
    public func render(_ entry: MetricsEntry) -> AnyView? {
        guard let data: DataType = entry.data(self) else {
            return nil
        }
        return AnyView(RescueTimeView(data: data))
    }
    
}
