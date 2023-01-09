//Created by Alexander Skorulis on 9/1/2023.

import Combine
import Foundation

final class MetricsDashboardViewModel: ObservableObject {
    
    private var subscribers: Set<AnyCancellable> = []
    
    let store: MetricsStore
    let plugins: PluginManager
    
    init(store: MetricsStore,
         plugins: PluginManager
    ) {
        self.store = store
        self.plugins = plugins
        
        store.objectWillChange.sink { [unowned self] in
            self.objectWillChange.send()
        }
        .store(in: &subscribers)
    }
    
}

// MARK: - Logic

extension MetricsDashboardViewModel {
    
    var entries: [MetricsEntry] {
        return store.currentData.entries
    }
    
    /*func pairs(entry: MetricsEntry) -> (any PluginData)? {
        
    }*/
    
}

struct PluginData<T: DataSourcePlugin> {
    
    private let plugin: T
    private let data: T.DataType
    
    init(_ plugin: T, _ data: T.DataType) {
        self.plugin = plugin
        self.data = data
    }
    
}
