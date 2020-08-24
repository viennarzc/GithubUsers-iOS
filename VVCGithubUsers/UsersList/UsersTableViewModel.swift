//
//  UsersTableViewModel.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/13/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UsersTableViewModel {
  var cellViewModels: [CellItemable] = []

  private var lastUserID: Int64 = 0
  private(set) var selectedUser: CellItemable?

  private(set) var profileViewModel: ProfileViewModel?

  func setSelectedUser(indexPath: IndexPath) {
    selectedUser = cellViewModels[indexPath.row]

    if let selected = selectedUser {
      profileViewModel = ProfileViewModel(userName: selected.userName, id: selected.id)
    }

  }

  func fetchUsers(completion: @escaping (Error?) -> Void) {
  
    if let users = fetchFromStorage(),
      !users.isEmpty {
      self.cellViewModels = mapToCellViewModels(from: users)
      completion(nil)
      return
    }


    NetworkManager.shared.fetchUsers { (result) in
      switch result {
      case .failure(let error):
        completion(error)

      case .success(let users):
        if let lastUser = users.last {
          self.lastUserID = lastUser.id
        }

        self.cellViewModels = self.mapToCellViewModels(from: users)

        completion(nil)
      }

    }
  }
  
  func mapToCellViewModels(from users: [GitHubUser]) -> [CellItemable] {
    let mapped = users.enumerated().map { (index, element: GitHubUser) in
      return UserTableCellViewModel(user: element, index: index)
    }
    
    return mapped
  }

  func fetchMoreUsers(completion: @escaping (Error?) -> Void) {
    print("fire fetch more users")
    NetworkManager.shared.fetchUsers(since: self.lastUserID) { (result) in
      switch result {
      case .failure(let error):
        completion(error)

      case .success(let users):
        if let lastUser = users.last {
          self.lastUserID = lastUser.id
        }

        let mappedUsers = users.enumerated().map { (index, element: GitHubUser) in
          return UserTableCellViewModel(user: element, index: index)
        }

        self.cellViewModels.append(contentsOf: mappedUsers)

        completion(nil)
      }

    }
  }

  func fetchFromStorage() -> [GitHubUser]? {

    let managedObjectContext = PersistenceManager.shared.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<GitHubUser>(entityName: "GitHubUser")
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]

    do {
      let users = try managedObjectContext.fetch(fetchRequest)
      return users
    } catch let error {
      print(error)
      return nil
    }
  }

}


protocol CellItemable {
  var userName: String { get set }
  var id: Int64 { get set }
  var details: String { get set }

  func cellInstance(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
  var cellType: CellType { get set }

}

public enum CellType {
  case note
  case normal
  case inverted
}

