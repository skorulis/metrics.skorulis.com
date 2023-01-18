//  Created by Alexander Skorulis on 11/12/2022.

import Foundation

public struct MetricsResultModel: Codable {
    public var entries: [MetricsWeekEntry]
    
    public init(entries: [MetricsWeekEntry]) {
        self.entries = entries
    }
    
    public func lastPush(repo: String) -> Date? {
        for entry in entries.reversed() {
            if let date = entry.lastPush(repo: repo) {
                return date
            }
        }
        return nil
    }
    
    public func entryMatching(_ week: Date) -> MetricsWeekEntry? {
        return entries.first(where: {$0.weekStartDate == week})
    }
    
    public mutating func replace(entry: MetricsWeekEntry) {
        if let index = entries.firstIndex(where: {$0.week == entry.week}) {
            self.entries[index] = entry
        } else {
            self.entries.append(entry)
        }
    }
}

struct GenericCodingKeys: CodingKey, ExpressibleByStringLiteral {
    // MARK: CodingKey
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { return nil }

    // MARK: ExpressibleByStringLiteral
    typealias StringLiteralType = String
    init(stringLiteral: StringLiteralType) { self.stringValue = stringLiteral }
}
