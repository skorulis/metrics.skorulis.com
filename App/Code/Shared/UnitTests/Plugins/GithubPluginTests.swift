//  Created by Alexander Skorulis on 22/1/2023.

import Foundation
@testable import Shared
import XCTest

final class GithubPluginTests: XCTestCase {
    
    private let sut = GithubPlugin()
    
    func test_mergeNoNewData() {
        var entry = MetricsEntry(date: Date())
        entry.setData(plugin: sut, data: Self.basicData)
        let newEntry = MetricsEntry(date: Date())
        
        entry.merge(other: newEntry, plugin: sut)
        
        let newData = entry.data(plugin: sut)!
        
        XCTAssertEqual(newData["Test"]?.languageBytes, Self.basicData["Test"]?.languageBytes)
        XCTAssertEqual(newData["Test"]?.commitCount, 5)
        XCTAssertEqual(newData["Test"]?.diff?.languageBytes, ["Swift": 50])
        XCTAssertEqual(newData["Test"]?.diff?.commitCount, 10)
    }
    
    func test_mergeOnlyNew() {
        var entry = MetricsEntry(date: Date())
        var newEntry = MetricsEntry(date: Date())
        newEntry.setData(plugin: sut, data: Self.basicData)
        entry.merge(other: newEntry, plugin: sut)
        let newData = entry.data(plugin: sut)!
        XCTAssertEqual(newData["Test"]?.languageBytes, Self.basicData["Test"]?.languageBytes)
        XCTAssertEqual(newData["Test"]?.commitCount, 5)
        XCTAssertEqual(newData["Test"]?.diff?.languageBytes, ["Swift": 50])
        XCTAssertEqual(newData["Test"]?.diff?.commitCount, 10)
    }
    
    func test_doubleMerge() {
        var entry = MetricsEntry(date: Date())
        var newEntry = MetricsEntry(date: Date())
        newEntry.setData(plugin: sut, data: Self.basicData)
        entry.merge(other: newEntry, plugin: sut)
        entry.merge(other: newEntry, plugin: sut)
        
        let newData = entry.data(plugin: sut)!
        XCTAssertEqual(newData["Test"]?.commitCount, 10)
        XCTAssertEqual(newData["Test"]?.diff?.languageBytes, ["Swift": 100])
        XCTAssertEqual(newData["Test"]?.diff?.commitCount, 20)
    }
    
    private static var basicData: [String: RepoMetrics] {
        var data: [String: RepoMetrics] = [:]
        let diff = RepoChange(languageBytes: ["Swift": 50], commitCount: 10)
        data["Test"] = RepoMetrics(
            languageBytes: ["Swift": 100],
            lastPush: Date(),
            commitCount: 5,
            diff: diff
        )
        return data
    }
}
