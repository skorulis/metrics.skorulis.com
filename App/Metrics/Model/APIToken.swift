//Created by Alexander Skorulis on 8/1/2023.

import Foundation

public struct APIToken: Identifiable {
    let name: String
    let key: String
    
    public var id: String { key }
}
