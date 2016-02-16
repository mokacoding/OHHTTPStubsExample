//
//  NetworkStubTests.swift
//  OHHTTPStubsSample
//
//  Created by Giovanni on 16/02/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import XCTest
@testable import OHHTTPStubsSample

class NetworkStubTests: XCTestCase {

  func testGetRequest() {
    let client = GitHubClient()

    let expectation = self.expectationWithDescription("d")
    client.mokacodingRepos { repos, error in

      XCTAssertEqual(repos?.count, 5)

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(5, handler: .None)
  }
}
