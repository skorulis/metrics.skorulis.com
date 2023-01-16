//  Created by Alexander Skorulis on 11/12/2022.

import ASKCore
import Foundation

public final class TokensService {
    
    private let store: PKeyValueStore
    
    init(store: PKeyValueStore) {
        self.store = store
    }
    
    public func value(token: APIToken) -> String? {
        return store.string(forKey: token.key)
    }
    
    public func set(value: String, token: APIToken) {
        store.set(value, forKey: token.key)
    }
    
    public func values<T: DataSourcePlugin>(plugin: T) -> [String: String] {
        var result: [String: String] = [:]
        for token in plugin.tokenKeys {
            if let value = value(token: token) {
                result[token.key] = value
            }
        }
        return result
    }
    
}

