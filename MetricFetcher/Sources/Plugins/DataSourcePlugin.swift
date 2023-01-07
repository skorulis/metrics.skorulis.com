//  Created by Alexander Skorulis on 7/1/2023.

import Foundation

protocol DataSourcePlugin {
    
    associatedtype DataType: Codable
    
    var keyName: String { get }
    
    
}
