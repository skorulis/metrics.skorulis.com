//  Created by Alexander Skorulis on 18/1/2023.

import Foundation

public struct MetricsEntry: Codable, Identifiable {
    
    public let day: String
    
    public func data<T: DataSourcePlugin>(plugin: T) -> T.DataType? {
        return pluginData[T.keyName] as? T.DataType
    }
    
    public mutating func setData<T: DataSourcePlugin>(plugin: T, data: T.DataType?) {
        pluginData[T.keyName] = data
    }
    
    public func data<T: DataSourcePlugin>(_ plugin: T.Type) -> T.DataType? {
        return pluginData[T.keyName] as? T.DataType
    }
    public mutating func setData<T: DataSourcePlugin>(_ plugin: T.Type, data: T.DataType?) {
        pluginData[T.keyName] = data
    }
    
    public var pluginData: [String: any PluginDataType]
    
    public init(day: String) {
        self.day = day
        pluginData = [:]
    }
    
    public init(date: Date) {
        let dayStart = Calendar.current.startOfDay(for: date)
        self.init(day: Self.dateFormatter.string(from: dayStart))
    }
    
    var date: Date {
        return Self.dateFormatter.date(from: day)!
    }
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    public init(from decoder: Decoder) throws {
        let plugins = decoder.userInfo[.init(rawValue: "plugins")!] as! [String: any DataSourcePlugin]
        let container = try decoder.container(keyedBy: GenericCodingKeys.self)
        self.day = try container.decode(String.self, forKey: "day")
        
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
        try container.encode(day, forKey: "day")
        
        for (key, value) in pluginData {
            try container.encode(value, forKey: .init(stringLiteral: key))
        }
    }
    
    public mutating func merge(other: MetricsEntry, plugins: [any DataSourcePlugin]) {
        for plugin in plugins {
            merge(other: other, plugin: plugin)
        }
    }
    
    public mutating func merge<T: DataSourcePlugin>(other: MetricsEntry, plugin: T) {
        guard let newData = other.data(plugin: plugin) else {
            return
        }
        guard let selfData = self.data(plugin: plugin) else {
            self.setData(plugin: plugin, data: newData)
            return
        }
        let merged = plugin.merge(data: selfData, newData: newData)
        self.setData(plugin: plugin, data: merged)
    }
    
    public var id: String { day }
    
}

public typealias PluginDataType = Codable


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
