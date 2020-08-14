//
//  NetworkManager.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/12/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let imageCache = NSCache<AnyObject, AnyObject>()

final class NetworkManager {
  enum Result<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
  }

  static let shared = NetworkManager()

  var persistentContainer: NSPersistentContainer = {

    let container = NSPersistentContainer(name: "VVCGithubUsers")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {

        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  private let session: URLSession?
  private let baseUrlString = "https://api.github.com"
  private var dataTask: URLSessionDataTask?

  init() {
    let config = URLSessionConfiguration.default
    config.waitsForConnectivity = true

    session = URLSession(configuration: config)
  }

  func fetchUsers(since: Int = 0, completion: @escaping (Result<[GitHubUser], Error>) -> Void) {

    if var urlComponents = URLComponents(string: baseUrlString) {
      urlComponents.path = "/users"
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

    if var urlComponents = URLComponents(string: baseUrlString) {
      urlComponents.path = "/users/\(loginName)"

      guard let url = urlComponents.url else { return }

      dataTask = session?.dataTask(with: url) { [weak self] data, response, error in
        defer {
          self?.dataTask = nil
        }

        if let error = error {
          completion(.failure(error))
          return
        }


        if let data = data,
          let response = response as? HTTPURLResponse,
          response.statusCode == 200 {

          do {
            //Decode

            guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
              fatalError("Failed to retrieve managed object context")
            }

            let managedObjectContext = self?.persistentContainer.viewContext
            let decoder = JSONDecoder()
            decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext

            let user = try decoder.decode(UserProfile.self, from: data)

            try managedObjectContext!.save()

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
