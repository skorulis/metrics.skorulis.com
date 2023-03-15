//  Created by Alexander Skorulis on 6/3/2023.

import Foundation

final class FetchService: ObservableObject {
    
    private let fetchStatus: FetchStatusService
    private let plugins: PluginManager
    private let store: MetricsStore
    private let tokens: TokensService
    private let dataService: DataService
    
    @Published var isFetching: Bool = false
    
    init(fetchStatus: FetchStatusService,
         plugins: PluginManager,
         store: MetricsStore,
         tokens: TokensService,
         dataService: DataService
    ) {
        self.fetchStatus = fetchStatus
        self.plugins = plugins
        self.store = store
        self.tokens = tokens
        self.dataService = dataService
        
    }
    
    func fetch() async {
        guard !isFetching else { return }
        self.isFetching = true
        defer {
            self.isFetching = false
        }
        await fetchStatus.start()
        do {
            let todo = plugins.sorted
            
            let dayStart = Calendar.current.startOfDay(for: Date())
            let context = FetchContext(entries: store.entryMap, date: dayStart)
            for plugin in todo {
                await fetchStatus.set(status: .active(nil), plugin: plugin)
                let tokens = tokens.values(plugin: plugin)
                try await plugin.fetch(context: context, tokens: tokens)
                await fetchStatus.set(status: .finished, plugin: plugin)
                try Task.checkCancellation()
            }
            self.store.lastFetchTime = Date.now
            print("Saving results")
            store.entries = context.orderedEntries
            for date in context.changed {
                let entry = context.entry(date: date)
                try await dataService.upload(entry: entry)
                try Task.checkCancellation()
            }
            print("Finished upload")
            
        } catch {
            print(error)
        }
    }
    
}
