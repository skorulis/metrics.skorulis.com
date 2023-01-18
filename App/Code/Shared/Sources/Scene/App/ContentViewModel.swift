//  Created by Alexander Skorulis on 18/1/2023.

import Combine
import Foundation

public final class ContentViewModel: ObservableObject {
    
    private let store: MainStore
    private var subscribers: Set<AnyCancellable> = []
    
    init(store: MainStore) {
        self.store = store
        store.objectWillChange.sink { [unowned self] _ in
            self.objectWillChange.send()
        }
        .store(in: &subscribers)
    }
    
    var isLoggedIn: Bool {
        return store.isLoggedIn
    }
}
