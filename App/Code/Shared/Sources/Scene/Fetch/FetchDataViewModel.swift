//Created by Alexander Skorulis on 8/1/2023.

import ASKCore
import Combine
import Foundation

public final class FetchDataViewModel: ObservableObject {
    
    private let store: MetricsStore
    private let plugins: PluginManager
    private let tokens: TokensService
    private let dataService: DataService
    let fetchStatus: FetchStatusService
    
    @Published var isFetching: Bool = false
    
    private var subscribers: Set<AnyCancellable> = []
    
    init(store: MetricsStore,
         plugins: PluginManager,
         tokens: TokensService,
         dataService: DataService,
         fetchStatus: FetchStatusService
    ) {
        self.store = store
        self.plugins = plugins
        self.tokens = tokens
        self.dataService = dataService
        self.fetchStatus = fetchStatus
        self.fetchStatus.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
        .store(in: &subscribers)
    }
    
}

// MARK: - Computed values

extension FetchDataViewModel {
 
    var pluginList: [any DataSourcePlugin] {
        return plugins.sorted
    }
}

// MARK: - Logic

extension FetchDataViewModel {
    
    func fetch() {
        guard !isFetching else { return }
        self.isFetching = true
        defer {
            self.isFetching = false
        }
        Task {
            await fetchStatus.start()
            do {
                let todo = pluginList
                
                let dayStart = Calendar.current.startOfDay(for: Date())
                let context = FetchContext(entries: store.entryMap, date: dayStart)
                for plugin in todo {
                    await fetchStatus.set(status: .active(nil), plugin: plugin)
                    let tokens = tokens.values(plugin: plugin)
                    try await plugin.fetch(context: context, tokens: tokens)
                    await fetchStatus.set(status: .finished, plugin: plugin)
                }
                print("Saving results")
                store.entries = context.orderedEntries
                for date in context.changed {
                    let entry = context.entry(date: date)
                    try await dataService.upload(entry: entry)
                }
                print("Finished upload")
            } catch {
                print(error)
            }
        }
    }
    
}
