//  Created by Alexander Skorulis on 7/1/2023.

import Foundation
import SwiftUI

public protocol DataSourcePlugin {
    
    associatedtype DataType: PluginDataType
    associatedtype SettingsViewType: View
    
    var name: String { get }
    var keyName: String { get }
    var dataType: DataType.Type { get }
    
    var tokenKeys: [APIToken] { get }
    
    init()
    func fetch(context: FetchContext, tokens: [String: String]) async throws
    func merge(data: DataType, newData: DataType) -> DataType
    func settingsView(_ viewModel: SettingsViewModel) -> SettingsViewType
    
}

public extension DataSourcePlugin {
    var keyName: String {
        return String(describing: self)
    }
    
    func merge(entry: MetricsEntry, other: MetricsEntry) -> DataType? {
        guard let oldData = entry.data(self) else {
            return other.data(self)
        }
        guard let newData = other.data(self) else {
            return oldData
        }
        return merge(data: oldData, newData: newData)
    }
    
    func anySettingsView(_ viewModel: SettingsViewModel) -> AnyView {
        AnyView(settingsView(viewModel))
    }
}
