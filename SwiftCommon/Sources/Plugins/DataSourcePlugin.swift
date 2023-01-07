//  Created by Alexander Skorulis on 7/1/2023.

import Foundation

public protocol DataSourcePlugin {
    
    associatedtype DataType: Codable
    
    var keyName: String { get }
    var dataType: DataType.Type { get }
        
}
