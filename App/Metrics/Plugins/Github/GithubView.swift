//Created by Alexander Skorulis on 9/1/2023.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct GithubView {
    let data: [String: RepoMetrics]
}

// MARK: - Rendering

extension GithubView: View {
    
    var body: some View {
        Text("Github")
    }
}

// MARK: - Previews

struct GithubView_Previews: PreviewProvider {
    
    static var previews: some View {
        let data = [
            "ASKDesignSystem": RepoMetrics(languageBytes: ["Swift": 50], lastPush: Date(), commitCount: 20)
        ]
        GithubView(data: data)
    }
}

