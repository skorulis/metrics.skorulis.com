//Created by Alexander Skorulis on 23/9/2022.

import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct LoginView {
    
    @StateObject var viewModel: LoginViewModel
}

// MARK: - Rendering

extension LoginView: View {
    
    var body: some View {
        PageTemplate(nav: nav, content: content)
    }
    
    private func nav() -> some View {
        NavBar(mid: NavBarItem.title("Login"))
    }
    
    private func content() -> some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
            
            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
            
            Button(action: viewModel.login) {
                Text("Login")
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Previews

struct LoginView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = SharedAssembly().assembled().factory
        LoginView(viewModel: ioc.resolve())
    }
}

