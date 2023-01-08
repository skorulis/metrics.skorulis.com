//  Created by Alexander Skorulis on 13/12/2022.

import ASKCore
import Foundation

final class RescueTimeHTTPService: HTTPService {
    
    private let tokens: TokensService
    
    init(tokens: TokensService) {
        self.tokens = tokens
        super.init(
            baseURL: "https://www.rescuetime.com/anapi",
            logger: HTTPLogger(level: .errors)
        )
    }
    
    override func modify(request: inout URLRequest) throws {
        guard let rescueTimeToken = tokens.value(token: RescueTimePlugin.rescueTimeToken) else {
            fatalError("Missing rescue time token")
        }
        request.add(param: "key", value: rescueTimeToken)
    }
    
}
