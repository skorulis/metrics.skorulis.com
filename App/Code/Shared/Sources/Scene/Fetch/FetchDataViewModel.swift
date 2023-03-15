//Created by Alexander Skorulis on 8/1/2023.

import ASKCore
import Combine
import Foundation

public final class FetchDataViewModel: ObservableObject {
    
    let store: MetricsStore
    private let plugins: PluginManager
    private let fetchService: FetchService
    let fetchStatus: FetchStatusService
    
    private var subscribers: Set<AnyCancellable> = []
    
    @Published var lastUpdate: Date?
    
    init(store: MetricsStore,
         plugins: PluginManager,
         fetchStatus: FetchStatusService,
         fetchService: FetchService
    ) {
        self.store = store
        self.plugins = plugins
        self.fetchService = fetchService
        self.fetchStatus = fetchStatus
        self.fetchStatus.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
        .store(in: &subscribers)
        self.store.$lastFetchTime
            .assign(to: &$lastUpdate)
    }
    
}

// MARK: - Computed values

extension FetchDataViewModel {
 
    var pluginList: [any DataSourcePlugin] {
        return plugins.sorted
    }
    
    var lastUpdateString: String? {
        guard let time = lastUpdate else {
            return nil
        }
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("dd/MM/yyyy HH:mm")
        return df.string(from: time)
    }
}

// MARK: - Logic

extension FetchDataViewModel {
    
    func fetch() {
        Task {
            await self.fetchService.fetch()
        }
    }
    
}
