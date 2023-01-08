//Created by Alexander Skorulis on 8/1/2023.

import Foundation

final class FetchService {
    
    let plugins: PluginManager
    
    init(plugins: PluginManager) {
        self.plugins = plugins
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.userInfo[.pluginsKey] = plugins.plugins
        return decoder
    }
    
    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.userInfo[.pluginsKey] = plugins.plugins
        return encoder
    }
}
