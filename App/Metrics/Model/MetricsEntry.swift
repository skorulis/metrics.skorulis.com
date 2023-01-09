//Created by Alexander Skorulis on 9/1/2023.

import Foundation

public struct MetricsEntry: Codable, Identifiable {
    
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
    
    public var id: String { week }
    
}
