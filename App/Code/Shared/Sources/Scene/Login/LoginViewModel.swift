//Created by Alexander Skorulis on 23/9/2022.

import ASKCore
import Foundation
import Firebase
import FirebaseAuth

// MARK: - Memory footprint

final class LoginViewModel: ObservableObject {
    
    private let mainStore: MainStore
    private let errorService: PErrorService
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    init(mainStore: MainStore,
         errorService: PErrorService
    ) {
        self.mainStore = mainStore
        self.errorService = errorService
    }
    
}

// MARK: - Logic

extension LoginViewModel {
    
    func login() {
        guard !email.isEmpty, !password.isEmpty else { return }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            if let error {
                self?.errorService.handle(error: error)
            } else {
                DispatchQueue.main.async {
                    self?.mainStore.updateLoggedIn()
                }
            }
        }
    }
    
}
