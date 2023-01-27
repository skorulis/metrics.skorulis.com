//Created by Alexander Skorulis on 9/1/2023.

import Combine
import Foundation

public final class MetricsDashboardViewModel: ObservableObject {
    
    private var subscribers: Set<AnyCancellable> = []
    
    let store: MetricsStore
    let plugins: PluginManager
    
    @Published var groupType: GroupType = .day
    
    init(store: MetricsStore,
         plugins: PluginManager
    ) {
        self.store = store
        self.plugins = plugins
        
        store.objectWillChange
            .delayedChange()
            .sink { [unowned self] in
            self.objectWillChange.send()
        }
        .store(in: &subscribers)
    }
    
}

// MARK: - Logic

extension MetricsDashboardViewModel {
    
    var entries: [MetricsEntry] {
        switch groupType {
        case .day:
            return store.entries.reversed()
        case .week:
            return weekGrouped
        }
    }
    
    var weekGrouped: [MetricsEntry] {
        var entries: [MetricsEntry] = []
        for entry in store.entries {
            let weekStart = entry.date.startOfWeek
            var current = entries.last ?? MetricsEntry(date: weekStart)
            if current.date != weekStart {
                current = MetricsEntry(date: weekStart)
            }
            
            current.merge(other: entry, plugins: plugins.sorted)
            
            if entries.last?.date == weekStart {
                entries[entries.count - 1] = current
            } else {
                entries.append(current)
            }
        }
        return entries.reversed()
    }
    
    func title(entry: MetricsEntry) -> String {
        switch groupType {
        case .day:
            return DateFormatter.dayFormatter.string(from: entry.date)
        case .week:
            let dateString = DateFormatter.weekFormatter.string(from: entry.date)
            return "Week \(dateString)"
        }
    }
    
}

struct PluginData<T: DataSourcePlugin> {
    
    private let plugin: T
    private let data: T.DataType
    
    init(_ plugin: T, _ data: T.DataType) {
        self.plugin = plugin
        self.data = data
    }
    
}

// MARK: - Inner types

extension MetricsDashboardViewModel {
    enum GroupType: String, Identifiable, CaseIterable {
        case day, week
        
        var id: String { rawValue }
    }
}
