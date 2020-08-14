//
//  ProfileViewModel.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/14/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation
import CoreData

class ProfileViewModel {
  private let userName: String
  private let id: Int

  private(set) var userProfile: UserProfile?

  private let persistentContainer: NSPersistentContainer = NetworkManager.shared.persistentContainer


  init(userName: String, id: Int) {
    self.userName = userName
    self.id = id
  }

  func fetchUserProfile(completion: @escaping (Error?) -> Void) {
    if let users = fetchFromStorage(), (users.first(where: { $0.id == self.userProfile?.id }) != nil) {
      self.userProfile = users.first(where: { $0.id == self.userProfile?.id })
      completion(nil)
      return
    }

    NetworkManager.shared.fetchUser(with: userName) { (result) in
      switch result {
      case .failure(let error):
        completion(error)
      case .success(let user):
        self.userProfile = user
        completion(nil)
      }
    }
  }

  func fetchFromStorage() -> [UserProfile]? {

    let managedObjectContext = self.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<UserProfile>(entityName: "UserProfile")
    fetchRequest.predicate =  NSPredicate(format: "id = %@", "\(String(describing: self.id))")

    do {
      let user = try managedObjectContext.fetch(fetchRequest)
      return user
    } catch let error {
      print(error)
      return nil
    }
  }
}
