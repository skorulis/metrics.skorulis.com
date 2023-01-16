//Created by Alexander Skorulis on 8/1/2023.

import Foundation

public struct APIToken: Identifiable {
    public let name: String
    public let key: String
    
    public var id: String { key }
}
