//
//  GitHubClient.swift
//  OHHTTPStubsSample
//
//  Created by Giovanni on 17/02/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import Foundation


struct Resource {
  let id: String
  let aProperty: String
  let anotherPropert: String
}

class APIClient {

  let baseURL: NSURL
  var session: NSURLSession!

  init(baseURL: NSURL) {
    self.baseURL = baseURL

    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    self.session = NSURLSession(configuration: configuration)
  }

  enum Endpoint {
    case GetResourceWithId

    var method: String {
      switch self {
      case .GetResourceWithId: return "GET"
      }
    }

    var path: String {
      switch self {
      case .GetResourceWithId: return "resources/"
      }
    }

    func requestWithParameters(baseURL: NSURL, parameters: [String: AnyObject]) -> NSURLRequest? {
      switch self {
      case .GetResourceWithId:
        guard let id = parameters["id"] as? String else {
          return .None
        }

        let url = baseURL.URLByAppendingPathComponent(path).URLByAppendingPathComponent(id)

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method

        return request
      }
    }
  }

  func performAPIRequest(endpoint: Endpoint, parameters: [String: AnyObject], completion: ([String: AnyObject]?, ErrorType?) -> ()) {
    guard let request = endpoint.requestWithParameters(baseURL, parameters: parameters) else {
      // FIXME: This should return a proper error
      completion(.None, .None)
      return
    }

    let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
      if let error = error {
        completion(.None, error)
        return
      }

      guard let data = data else {
        // FIXME: This should return a proper error
        completion(.None, .None)
        return
      }

      do {
        guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else {

          return
        }

        completion(json, .None)
      } catch {
        // FIXME: This should return a proper error
        completion(.None, .None)
      }
    }

    task.resume()
  }

  func getResource(withId id: String, completion: (resource: Resource?, error: ErrorType?) -> ()) {
    performAPIRequest(.GetResourceWithId, parameters: ["id": id]) { json, error in
      guard let json = json else {
        completion(resource: .None, error: error)
        return
      }

      guard let
        id = json["id"] as? String,
        aProperty = json["foo"] as? String,
        anotherProperty = json["bar"] as? String
        else {
          // FIXME: This should return a proper error
          completion(resource: .None, error: .None)
          return
      }

      let resource = Resource(id: id, aProperty: aProperty, anotherPropert: anotherProperty)
      completion(resource: resource, error: .None)
    }
  }
}