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

  let baseURL: URL
  var session: URLSession

  init(baseURL: URL) {
    self.baseURL = baseURL

    let configuration = URLSessionConfiguration.default
    self.session = URLSession(configuration: configuration)
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

    func requestWithParameters(baseURL: URL, parameters: [String: Any]) -> URLRequest? {
      switch self {
      case .GetResourceWithId:
        guard let id = parameters["id"] as? String else {
          return .none
        }

        let url = baseURL.appendingPathComponent(path).appendingPathComponent(id)

        var request = URLRequest(url: url)
        request.httpMethod = method

        return request
      }
    }
  }

  func performAPIRequest(endpoint: Endpoint, parameters: [String: Any], completion: @escaping ([String: Any]?, Error?) -> ()) {
    guard let request = endpoint.requestWithParameters(baseURL: baseURL, parameters: parameters) else {
      // FIXME: This should return a proper error
      completion(.none, .none)
      return
    }

    let task = session.dataTask(with: request) { (data, response, error) -> Void in
      if let error = error {
        completion(.none, error)
        return
      }

      guard let data = data else {
        // FIXME: This should return a proper error
        completion(.none, .none)
        return
      }

      do {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {

          return
        }

        completion(json, .none)
      } catch {
        // FIXME: This should return a proper error
        completion(.none, .none)
      }
    }

    task.resume()
  }

  func getResource(withId id: String, completion: @escaping (_ resource: Resource?, _ error: Error?) -> ()) {
    performAPIRequest(endpoint: .GetResourceWithId, parameters: ["id": id]) { json, error in
      guard let json = json else {
        completion(.none, error)
        return
      }

      guard let
        id = json["id"] as? String,
        let aProperty = json["foo"] as? String,
        let anotherProperty = json["bar"] as? String
        else {
          // FIXME: This should return a proper error
          completion(.none, .none)
          return
      }

      let resource = Resource(id: id, aProperty: aProperty, anotherPropert: anotherProperty)
      completion(resource, .none)
    }
  }
}
