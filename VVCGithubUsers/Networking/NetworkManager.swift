//
//  NetworkManager.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/12/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation

final class NetworkManager {
  static let shared = NetworkManager()
  
  private let session = URLSession(configuration: .default)
  private let url = URL(string: "​https://api.github.com/users?since=0")
  var dataTask: URLSessionDataTask?
  
  func fetchUsers(since: Int = 0) {
//    let task = session.
    
    if var urlComponents = URLComponents(string: "https://api.github.com/users"){
      urlComponents.query = "since=\(since)"
      
      guard let url = urlComponents.url else { return }
      
      dataTask = session.dataTask(with: url) { [weak self] data, response, error in
        defer {
          self?.dataTask = nil
        }
        
        if let error = error {
          print(error.localizedDescription)
          return
        }
        
        if let data = data,
          let response = response as? HTTPURLResponse,
          response.statusCode == 200 {
          
          print("data",data)
          
        }
        
      }
    }
    
    dataTask?.resume()
    
    
  }
}
