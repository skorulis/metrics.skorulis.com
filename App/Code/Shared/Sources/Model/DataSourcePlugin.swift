//  Created by Alexander Skorulis on 7/1/2023.

import Foundation
import SwiftUI

/// Simple protocol without associate types
public protocol SourcePlugin {
    static var keyName: String { get }
}

public protocol DataSourcePlugin: SourcePlugin {
    
    associatedtype DataType: PluginDataType
    associatedtype SettingsViewType: View
    
    var name: String { get }
    
    var dataType: DataType.Type { get }
    
    var tokenKeys: [APIToken] { get }
    
    func fetch(context: FetchContext, tokens: [String: String]) async throws
    func merge(data: DataType, newData: DataType) -> DataType
    func settingsView(_ viewModel: SettingsViewModel) -> SettingsViewType
    
}

public extension DataSourcePlugin {
    static var keyName: String {
        return "Shared.\(String(describing: self))"
    }
    
    func merge(entry: MetricsEntry, other: MetricsEntry) -> DataType? {
        guard let oldData = entry.data(plugin: self) else {
            return other.data(plugin: self)
        }
        guard let newData = other.data(plugin: self) else {
            return oldData
        }
        return merge(data: oldData, newData: newData)
    }
    
    func anySettingsView(_ viewModel: SettingsViewModel) -> AnyView {
        AnyView(settingsView(viewModel))
    }
}
