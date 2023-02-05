//  Created by Alexander Skorulis on 5/2/2023.

import Foundation
import SwiftUI

public final class LocationPlugin: DataSourcePlugin {
    
    public var name: String = "Location"
    
    public var dataType: LocationData.Type { DataType.self }
    public typealias DataType = LocationData
    
    public var tokenKeys: [APIToken] { [] }
    
    public init() {}
    
    public func fetch(context: FetchContext, tokens: [String : String]) async throws {
        // TODO
    }
    
    public func settingsView(_ viewModel: SettingsViewModel) -> some View {
        VStack {
            
        }
    }
    
    public func merge(data: LocationData, newData: LocationData) -> LocationData {
        let maxDistance = max(data.maxDistance, newData.maxDistance)
        
        return LocationData(maxDistance: maxDistance)
    }
 
    
}
