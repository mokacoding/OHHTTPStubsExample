//
//  GitHubClient.swift
//  OHHTTPStubsSample
//
//  Created by Giovanni on 17/02/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import Foundation


struct Repo { }

class GitHubClient {

  var session: NSURLSession!

  init() {
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    self.session = NSURLSession(configuration: configuration)
  }

  func mokacodingRepos(completion: (repos: [Repo]?, error: NSError?) -> Void) -> Void {
    let request = NSURLRequest(URL: NSURL(string: "https://api.github.com/orgs/mokacoding/repos?per_page=6")!)

    let task = self.session.dataTaskWithRequest(request) { (data, response, error) -> Void in
      if let error = error {
        completion(repos: .None, error: error)
        return
      }

      guard let data = data else {
        completion(repos: .None, error: .None)
        return
      }

      do {
        guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [ [String: AnyObject] ] else {

          return
        }

        completion(repos: json.map { _ in Repo() }, error: .None)
      } catch {
        completion(repos: .None, error: .None)
      }
    }

    task.resume()
  }
}