//  Created by Alexander Skorulis on 7/1/2023.

import Foundation

public final class PluginManager {
    
    public var plugins: [String: any DataSourcePlugin] = [:]
    
    public init() {
        
    }
    
    public func register<T: DataSourcePlugin>(plugin: T) {
        plugins[plugin.keyName] = plugin
    }
    
    public var sorted: [any DataSourcePlugin] {
        let values = Array(plugins.values)
        return values.sorted { d1, d2 in
            return d1.name < d2.name
        }
    }
    
}

extension CodingUserInfoKey {
    public static let pluginsKey = CodingUserInfoKey(rawValue: "plugins")!
}
