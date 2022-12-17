//  Created by Alexander Skorulis on 13/12/2022.

import ASKCore
import Foundation
import SwiftCommon

enum RescueTimeRequest {
 
    static func days() -> HTTPJSONRequest<[RescueTimeDay]> {
        let endpoint = "/daily_summary_feed"
        return HTTPJSONRequest<[RescueTimeDay]>(endpoint: endpoint)
    }
    
}
