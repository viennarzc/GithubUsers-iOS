//
//  NetworkManager.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/12/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

final class NetworkManager {
  enum Result<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
  }

  static let shared = NetworkManager()

  private let session: URLSession?
  private let usersUrlString = "https://api.github.com/users"
  private var dataTask: URLSessionDataTask?
  
  init() {
    let config = URLSessionConfiguration.default
    config.waitsForConnectivity = true
    
    session = URLSession(configuration: config)
  }

  func fetchUsers(since: Int = 0, completion: @escaping (Result<[GitHubUser], Error>) -> Void) {

    if var urlComponents = URLComponents(string: usersUrlString) {
      urlComponents.query = "since=\(since)"

      guard let url = urlComponents.url else { return }

      dataTask = session?.dataTask(with: url) { [weak self] data, response, error in
        defer {
          self?.dataTask = nil
        }

        if let error = error {
          completion(.failure(error))
          return
        }

        //Decode

        if let data = data,
          let response = response as? HTTPURLResponse,
          response.statusCode == 200 {

          let decoder = JSONDecoder()

          do {
            let users = try decoder.decode([GitHubUser].self, from: data)
            
            completion(.success(users))
            
          } catch {
            completion(.failure(error))
          }


        }

      }
    }

    dataTask?.resume()

  }
  
  func fetchUser(with loginName: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
    
    if var urlComponents = URLComponents(string: usersUrlString) {
      urlComponents.path = loginName

      guard let url = urlComponents.url else { return }

      dataTask = session?.dataTask(with: url) { [weak self] data, response, error in
        defer {
          self?.dataTask = nil
        }

        if let error = error {
          completion(.failure(error))
          return
        }

        //Decode

        if let data = data,
          let response = response as? HTTPURLResponse,
          response.statusCode == 200 {

          let decoder = JSONDecoder()

          do {
            let user = try decoder.decode(UserProfile.self, from: data)
            
            completion(.success(user))
            
          } catch {
            completion(.failure(error))
          }


        }

      }
    }

    dataTask?.resume()
    
  }

  func loadImages(with url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
    // image does not available in cache.. so retrieving it from url...
    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

      if error != nil {

      }

      DispatchQueue.main.async(execute: {

        if let unwrappedData = data, let image = UIImage(data: unwrappedData) {
          completion(image, nil)
        }

      })
    }).resume()
  }
}
