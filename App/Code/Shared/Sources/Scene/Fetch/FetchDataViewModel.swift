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
        
        var entry = MetricsEntry(date: Date())
        var gitData = GithubPlugin.DataType()
        gitData["test"] = .init(languageBytes: ["swift": 1000], lastPush: Date(), commitCount: 300)
        
        entry.setData(GithubPlugin(), data: gitData)
        dataService.save(entry: entry)
        
        dataService.fetch()
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
