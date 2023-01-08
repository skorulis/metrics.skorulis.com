//  Created by Alexander Skorulis on 11/12/2022.

import ASKCore
import Foundation

final class TokensService {
    
    private let store: PKeyValueStore
    
    init(store: PKeyValueStore) {
        self.store = store
    }
    
    func value(token: APIToken) -> String? {
        return store.string(forKey: token.key)
    }
    
    func set(value: String, token: APIToken) {
        store.set(value, forKey: token.key)
    }
    
}

