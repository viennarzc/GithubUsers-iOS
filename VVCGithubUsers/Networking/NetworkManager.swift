//
//  NetworkManager.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/12/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation

final class NetworkManager {
  enum Result<Success, Failure> where Failure: Error {
      case success(Success)
      case failure(Failure)
  }
  
  
  static let shared = NetworkManager()

  private let session = URLSession(configuration: .default)
  private let urlString = "https://api.github.com/users"
  private var dataTask: URLSessionDataTask?

  func fetchUsers(since: Int = 0, completion: @escaping (Result<[GitHubUser], Error>) -> Void) {

    if var urlComponents = URLComponents(string: urlString) {
      urlComponents.query = "since=\(since)"

      guard let url = urlComponents.url else { return }

      dataTask = session.dataTask(with: url) { [weak self] data, response, error in
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
}
