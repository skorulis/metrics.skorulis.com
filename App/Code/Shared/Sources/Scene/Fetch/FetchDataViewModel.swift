//Created by Alexander Skorulis on 8/1/2023.

import Foundation
import ASKCore

public final class FetchDataViewModel: ObservableObject {
    
    private let store: MetricsStore
    private let plugins: PluginManager
    private let tokens: TokensService
    private let dataService: DataService
    
    init(store: MetricsStore,
         plugins: PluginManager,
         tokens: TokensService,
         dataService: DataService
    ) {
        self.store = store
        self.plugins = plugins
        self.tokens = tokens
        self.dataService = dataService
    }
    
}

// MARK: - Logic

extension FetchDataViewModel {
    
    func fetch() {
        Task {
            do {
                let todo = plugins.sorted
                let dayStart = Calendar.current.startOfDay(for: Date())
                let context = FetchContext(entries: store.entryMap, date: dayStart)
                for plugin in todo {
                    print("Fetching \(plugin.name)")
                    let tokens = tokens.values(plugin: plugin)
                    try await plugin.fetch(context: context, tokens: tokens)
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
