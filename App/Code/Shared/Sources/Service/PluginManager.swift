//  Created by Alexander Skorulis on 7/1/2023.

import Foundation

public final class PluginManager {
    
    public var dataPlugins: [String: any DataSourcePlugin] = [:]
    public var renderers: [any DataRendererPlugin] = []
    
    public init() {
        
    }
    
    public func register<T: DataSourcePlugin>(plugin: T) {
        dataPlugins[plugin.keyName] = plugin
    }
    
    public func register<T: DataRendererPlugin>(plugin: T) {
        renderers.append(plugin)
    }
    
    public var sorted: [any DataSourcePlugin] {
        let values = Array(dataPlugins.values)
        return values.sorted { d1, d2 in
            return d1.name < d2.name
        }
    }
    
}

extension CodingUserInfoKey {
    public static let pluginsKey = CodingUserInfoKey(rawValue: "plugins")!
}
