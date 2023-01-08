//Created by Alexander Skorulis on 8/1/2023.

import Foundation

final class MetricsStore: ObservableObject {
    
    var currentData: MetricsResultModel! {
        didSet {
            let data = try! encoder.encode(currentData)
            try! data.write(to: Self.saveFile)
        }
    }
    let plugins: PluginManager
    
    init(plugins: PluginManager) {
        self.plugins = plugins
        currentData = try! loadExisting()
        print("Using data at \(Self.saveFile.absoluteString)")
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

private extension MetricsStore {
    
    static var saveFile: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appending(path: "data.json")
    }
    
    func loadExisting() throws -> MetricsResultModel {
        if FileManager.default.fileExists(at: Self.saveFile) {
            let data = try Data(contentsOf: Self.saveFile)
            return try decoder.decode(MetricsResultModel.self, from: data)
        } else {
            return MetricsResultModel(entries: [])
        }
    }
    
}
