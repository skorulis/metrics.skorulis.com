//Created by Alexander Skorulis on 8/1/2023.

import Foundation
import ASKCore

public final class FetchDataViewModel: ObservableObject {
    
    private let store: MetricsStore
    private let plugins: PluginManager
    private let tokens: TokensService
    
    init(store: MetricsStore,
         plugins: PluginManager,
         tokens: TokensService
    ) {
        self.store = store
        self.plugins = plugins
        self.tokens = tokens
    }
    
}

// MARK: - Logic

extension FetchDataViewModel {
    
    func fetch() {
        Task {
            do {
                let todo = plugins.sorted
                let context = FetchContext(result: store.currentData, weekStartDate: Date().startOfWeek)
                for plugin in todo {
                    print("Fetching \(plugin.name)")
                    let tokens = tokens.values(plugin: plugin)
                    try await plugin.fetch(context: context, tokens: tokens)
                }
                print("Saving results")
                self.store.currentData = context.result
            } catch {
                print(error)
            }
        }
    }
    
    
}
