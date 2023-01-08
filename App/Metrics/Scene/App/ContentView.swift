//  Created by Alexander Skorulis on 8/1/2023.

import SwiftUI

struct ContentView: View {
    
    @Environment(\.factory) private var factory
    
    var body: some View {
        TabView {
            SettingsView(viewModel: factory.resolve())
                .tabItem {
                    Text("Settings")
                    Image(systemName: "gearshape.circle.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
