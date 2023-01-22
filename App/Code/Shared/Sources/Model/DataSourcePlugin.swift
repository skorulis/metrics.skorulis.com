//  Created by Alexander Skorulis on 7/1/2023.

import Foundation
import SwiftUI

public protocol DataSourcePlugin {
    
    associatedtype DataType: PluginDataType
    
    var name: String { get }
    var keyName: String { get }
    var dataType: DataType.Type { get }
    
    var tokenKeys: [APIToken] { get }
    
    func fetch(context: FetchContext, tokens: [String: String]) async throws
    
    func render(_ entry: MetricsEntry, _ data: DataType) -> AnyView
    func merge(data: DataType, newData: DataType) -> DataType
        
}

public extension DataSourcePlugin {
    var keyName: String {
        return String(describing: self)
    }
    
    func maybeRender(entry: MetricsEntry) -> AnyView {
        guard let data = entry.data(self) else {
            return AnyView(EmptyView())
        }
        return self.render(entry, data)
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
}
