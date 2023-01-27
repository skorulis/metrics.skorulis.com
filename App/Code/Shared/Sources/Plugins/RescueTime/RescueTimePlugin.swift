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
        for day in days {
            let date = MetricsEntry.dateFormatter.date(from: day.date)!
            var entry = context.entry(date: date)
            entry.setData(self, data: day)
            context.replace(entry: entry)
        }
    }
    
    public func merge(data: DataType, newData: DataType) -> DataType {
        return RescueTimeDay(
            productivity_pulse: data.productivity_pulse + newData.productivity_pulse,
            date: newData.date,
            total_hours: data.total_hours + newData.total_hours,
            very_productive_hours: data.very_productive_hours + newData.very_productive_hours,
            productive_hours: data.productive_hours + newData.productive_hours,
            neutral_hours: data.neutral_hours + newData.neutral_hours,
            distracting_hours: data.distracting_hours + newData.distracting_hours,
            very_distracting_hours: data.very_distracting_hours + newData.very_distracting_hours,
            all_productive_hours: data.all_productive_hours + newData.all_productive_hours,
            all_distracting_hours: data.all_distracting_hours + newData.all_distracting_hours,
            uncategorized_hours: data.uncategorized_hours + newData.uncategorized_hours,
            business_hours: data.business_hours + newData.business_hours,
            communication_and_scheduling_hours: data.communication_and_scheduling_hours + newData.communication_and_scheduling_hours,
            social_networking_hours: data.social_networking_hours + newData.social_networking_hours,
            design_and_composition_hours: data.design_and_composition_hours + newData.design_and_composition_hours,
            entertainment_hours: data.entertainment_hours + newData.entertainment_hours,
            news_hours: data.news_hours + newData.news_hours,
            software_development_hours: data.software_development_hours + newData.software_development_hours,
            reference_and_learning_hours: data.reference_and_learning_hours + newData.reference_and_learning_hours,
            shopping_hours: data.shopping_hours + newData.shopping_hours,
            utilities_hours: data.utilities_hours + newData.utilities_hours
        )
    }
    
}
