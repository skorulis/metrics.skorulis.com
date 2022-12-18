//  Created by Alexander Skorulis on 18/12/2022.

import Foundation
import SwiftUI
import SwiftCommon

// MARK: - Memory footprint

struct CodeOverviewView {
 
    let data: MetricsResultModel
}

// MARK: - Rendering

extension CodeOverviewView: View {
    
    var body: some View {
        VStack {
            Text(data.entries.last!.week)
            Text("Commits: \(diff.commitCount)")
            ForEach(languages, id: \.self) { lang in
                Text("\(lang): \(bytes(lang))")
            }
        }
    }
    
    var diff: RepoChange {
        return data.entries.last!.totalDiff
    }
    
    func bytes(_ lang: String) -> Int {
        return diff.languageBytes[lang] ?? 0
    }
                     
    
    var languages: [String] {
        return Array(diff.languageBytes.keys)
    }
}

// MARK: - Previews

struct CodeOverviewView_Previews: PreviewProvider {
    
    static var previews: some View {
        let entries = [
            MetricsEntry(week: "2022-12-12"),
            testEntry1
        ]
        let data = MetricsResultModel(entries: entries)
        CodeOverviewView(data: data)
    }
    
    static var testEntry1: MetricsEntry {
        var entry = MetricsEntry(week: "2022-12-12")
        let diff = RepoChange(languageBytes: ["Swift": 1000], commitCount: 5)
        entry.repos["Test1"] = RepoMetrics(
            languageBytes: [:],
            lastPush: Date(),
            commitCount: 5,
            diff: diff
        )
        
        return entry
    }
}

