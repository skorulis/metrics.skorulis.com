//  Created by Alexander Skorulis on 7/1/2023.

import ASKCore
import Foundation

public final class PluginManager {
    
    public var renderers: [any DataRendererPlugin] = []
    
    private let factory: PFactory
    
    public init(factory: PFactory) {
        self.factory = factory
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
    
    var dataPlugins: [String: any DataSourcePlugin] {
        let plugins = factory.resolveAll(type: SourcePlugin.self)
        return Dictionary(grouping: plugins) { plugin in
            type(of: plugin).keyName
        }
        .mapValues { $0[0] as! (any DataSourcePlugin) }
    }
    
}

extension CodingUserInfoKey {
    public static let pluginsKey = CodingUserInfoKey(rawValue: "plugins")!
}
