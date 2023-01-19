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
    
    public func render(_ entry: MetricsEntry) -> AnyView? {
        guard let data: DataType = entry.data(self) else {
            return nil
        }
        return AnyView(RescueTimeView(data: data))
    }
    
}
