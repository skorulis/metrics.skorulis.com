//  Created by Alexander Skorulis on 12/12/2022.

import Foundation
import XCTest
@testable import MetricFetcher

final class GithubRequestTests: XCTestCase {
    
    func test_abc() throws {
        let input = """
link: <https://api.github.com/repositories/573935771/commits?per_page=1&page=2>; rel="next", <https://api.github.com/repositories/573935771/commits?per_page=1&page=12>; rel="last"
"""
        
        let result = try CommitCountRequest.extractPage(link: input)
        XCTAssertEqual(result, 12)
    }
}
