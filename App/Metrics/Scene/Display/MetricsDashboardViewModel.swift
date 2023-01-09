//Created by Alexander Skorulis on 9/1/2023.

import Combine
import Foundation

final class MetricsDashboardViewModel: ObservableObject {
    
    private var subscribers: Set<AnyCancellable> = []
    
    let store: MetricsStore
    
    init(store: MetricsStore) {
        self.store = store
        
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
    
}

