//  Created by Alexander Skorulis on 13/12/2022.

import ASKCore
import Foundation

final class RescueTimeHTTPService: HTTPService {
    
    private let token: String
    
    init(token: String) {
        self.token = token
        super.init(
            baseURL: "https://www.rescuetime.com/anapi",
            logger: HTTPLogger(level: .errors)
        )
    }
    
    override func modify(request: inout URLRequest) throws {
        request.add(param: "key", value: token)
    }
    
}
