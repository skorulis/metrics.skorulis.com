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
        VStack {
            Text("Commits: \(totalCommits)")
            ForEach(languageLines, id: \.0) { line in
                Text("\(line.0): \(line.1)")
            }
        }
    }
    
    var totalCommits: Int {
        let commits = data.values.map { repo in
            return repo.diff?.commitCount ?? 0
        }
        return commits.reduce(0, +)
    }
    
    var languageLines: [(String, Int)] {
        var dict: [String: Int] = [:]
        for repo in data.values {
            for (lang, bytes) in (repo.diff?.languageBytes ?? [:]) {
                let total = (dict[lang] ?? 0) + bytes
                dict[lang] = total
            }
        }
        var ret: [(String, Int)] = []
        for (key, value) in dict {
            ret.append((key, value))
        }
        
        return ret.filter { $0.1 != 0}.sorted { s1, s2 in
            return s1.1 > s2.1
        }
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

