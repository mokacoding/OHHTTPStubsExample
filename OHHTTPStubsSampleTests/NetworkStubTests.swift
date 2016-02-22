//
//  NetworkStubTests.swift
//  OHHTTPStubsSample
//
//  Created by Giovanni on 16/02/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import XCTest
@testable import OHHTTPStubsSample
import OHHTTPStubs

class NetworkStubTests: XCTestCase {

  func testGetResourceSuccess() {
    // Arrange
    //
    // Setup network stubs
    let testHost = "te.st"
    let id = "42-abc"
    let stubbedJSON = [
      "id": id,
      "foo": "some text",
      "bar": "some other text",
    ]
    stub(isHost(testHost) && isPath("/resources/\(id)")) { _ in
      return OHHTTPStubsResponse(
        JSONObject: stubbedJSON,
        statusCode: 200,
        headers: .None
      )
    }
    // Setup System Under Test
    let client = APIClient(baseURL: NSURL(string: "http://\(testHost)")!)
    let expectation = self.expectationWithDescription("calls the callback with a resource object")

    // Act
    //
    client.getResource(withId: id) { resource, error in

      // Assert
      //
      XCTAssertNil(error)
      XCTAssertEqual(resource?.id, stubbedJSON["id"])
      XCTAssertEqual(resource?.aProperty, stubbedJSON["foo"])
      XCTAssertEqual(resource?.anotherPropert, stubbedJSON["bar"])

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(0.3, handler: .None)
    
    OHHTTPStubs.removeAllStubs()
  }

  func testGetResourceFailure() {
    // Arrange
    //
    // Setup network stubs
    let testHost = "te.st"
    let id = "42-abc"
    let expectedError = NSError(domain: "test", code: 42, userInfo: .None)
    stub(isHost(testHost) && isPath("/resources/\(id)")) { _ in
      return OHHTTPStubsResponse(error: expectedError)
    }
    // Setup System Under Test
    let client = APIClient(baseURL: NSURL(string: "http://\(testHost)")!)
    let expectation = self.expectationWithDescription("calls the callback with an error")

    // Act
    //
    client.getResource(withId: id) { resource, error in

      // Assert
      //
      XCTAssertNil(resource)
      XCTAssertEqual(error as? NSError, expectedError)

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(0.3, handler: .None)

    OHHTTPStubs.removeAllStubs()
  }
}
