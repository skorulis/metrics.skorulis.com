//Created by Alexander Skorulis on 8/1/2023.

import Foundation
import SwiftUI

public final class SettingsViewModel: ObservableObject {
    
    private let tokens: TokensService
    private let plugins: PluginManager
    
    init(tokens: TokensService,
         plugins: PluginManager
    ) {
        self.tokens = tokens
        self.plugins = plugins
    }
}

// MARK: - Logic

extension SettingsViewModel {
    
    var tokenKeys: [APIToken] {
        return plugins.sorted.flatMap { $0.tokenKeys }
    }
    
    func tokenBinding(_ token: APIToken) -> Binding<String> {
        return Binding<String> { [unowned self] in
            return self.tokens.value(token: token) ?? ""
        } set: { [unowned self] newValue in
            self.tokens.set(value: newValue, token: token)
        }
    }
    
    func startAddPlugin() {
        
    }
}
