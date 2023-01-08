//  Created by Alexander Skorulis on 11/12/2022.

import Foundation

public struct MetricsResultModel: Codable {
    public var entries: [MetricsEntry]
    
    public init(entries: [MetricsEntry]) {
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
    
    public func entryMatching(_ week: Date) -> MetricsEntry? {
        return entries.first(where: {$0.weekStartDate == week})
    }
    
    public func lastRepoMetrics(repo: String, before: Date) -> RepoMetrics? {
        for entry in entries.reversed() {
            if let value = entry.repos[repo], entry.weekStartDate < before {
                return value
            }
        }
        return nil
    }
    
    
    public mutating func replace(entry: MetricsEntry) {
        if let index = entries.firstIndex(where: {$0.week == entry.week}) {
            self.entries[index] = entry
        } else {
            self.entries.append(entry)
        }
    }
}

public struct MetricsEntry: Codable {
    
    public let week: String
    public func data<T: DataSourcePlugin>(_ plugin: T) -> T.DataType? {
        return pluginData[plugin.keyName] as? T.DataType
    }
    public mutating func setData<T: DataSourcePlugin>(_ plugin: T, data: T.DataType?) {
        pluginData[plugin.keyName] = data
    }
    
    public var pluginData: [String: any Codable]
    
    public init(week: String) {
        self.week = week
        pluginData = [:]
    }
    
    var weekStartDate: Date {
        return Self.dateFormatter.date(from: week)!
    }
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    public static var weekStart: String {
        let weekStart = Date().startOfWeek
        return dateFormatter.string(from: weekStart)
    }
    
    public init(from decoder: Decoder) throws {
        let plugins = decoder.userInfo[.init(rawValue: "plugins")!] as! [String: any DataSourcePlugin]
        let container = try decoder.container(keyedBy: GenericCodingKeys.self)
        self.week = try container.decode(String.self, forKey: "week")
        
        pluginData = [:]
        for (key, value) in plugins {
            let objType = value.dataType
            
            if let data = try container.decodeIfPresent(objType, forKey: .init(stringLiteral: key)) {
                pluginData[key] = data
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: GenericCodingKeys.self)
        try container.encode(week, forKey: "week")
        
        for (key, value) in pluginData {
            try container.encode(value, forKey: .init(stringLiteral: key))
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
