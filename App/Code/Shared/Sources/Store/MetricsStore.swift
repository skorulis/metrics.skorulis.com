//Created by Alexander Skorulis on 8/1/2023.

import Foundation

public final class MetricsStore: ObservableObject {
    
    @Published var entries: [MetricsEntry] = [] {
        didSet {
            let data = try! encoder.encode(entries)
            try! data.write(to: Self.saveFile)
        }
    }
    
    let plugins: PluginManager
     
    init(plugins: PluginManager) {
        self.plugins = plugins
        self.entries = try! loadExisting()
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
    
    var entryMap: [Date: MetricsEntry] {
        return Dictionary(grouping: entries, by: {$0.date}).mapValues { $0[0] }
    }
    
    func replace(entry: MetricsEntry) {
        guard let index = entries.firstIndex(where: {$0.date == entry.date}) else {
            entries.append(entry)
            entries = entries.sorted(by: { m1, m2 in
                return m1.date < m2.date
            })
            return
        }
        entries[index] = entry
    }
    
}

private extension MetricsStore {
    
    static var saveFile: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appending(path: "metrics.json")
    }
    
    func loadExisting() throws -> [MetricsEntry] {
        if FileManager.default.fileExists(at: Self.saveFile) {
            let data = try Data(contentsOf: Self.saveFile)
            return (try? decoder.decode([MetricsEntry].self, from: data)) ?? []
        } else {
            return []
        }
    }
    
}
