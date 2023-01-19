//  Created by Alexander Skorulis on 7/1/2023.

import Foundation
import SwiftUI

public protocol DataSourcePlugin {
    
    associatedtype DataType: Codable
    
    var name: String { get }
    var keyName: String { get }
    var dataType: DataType.Type { get }
    
    var tokenKeys: [APIToken] { get }
    
    func fetch(context: FetchContext, tokens: [String: String]) async throws
    
    func render(_ entry: MetricsEntry) -> AnyView?
        
}
