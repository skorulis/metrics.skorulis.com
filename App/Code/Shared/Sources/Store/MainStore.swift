//  Created by Alexander Skorulis on 18/1/2023.

import FirebaseAuth
import Foundation

final class MainStore: ObservableObject {

    @Published var isLoggedIn: Bool
    
    init() {
        self.isLoggedIn = Auth.auth().currentUser != nil
    }
    
    func updateLoggedIn() {
        self.isLoggedIn = Auth.auth().currentUser != nil
    }
}
