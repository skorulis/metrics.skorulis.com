//  Created by Alexander Skorulis on 7/1/2023.

import Foundation
import SwiftCommon

final class RescueTimePlugin: DataSourcePlugin {
    typealias DataType = RescueTimeDay
    
    let keyName: String = "timeBreakdown"
    
    var dataType: RescueTimeDay.Type { RescueTimeDay.self }
    
}
