//
//  UsersTableViewModel.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/13/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation
import UIKit

class UsersTableViewModel {
  var cellViewModels: [CellItemable] = []

  private var lastUserID: Int16 = 0
  private(set) var selectedUser: CellItemable?
  
  private(set) var profileViewModel: ProfileViewModel?

  func setSelectedUser(indexPath: IndexPath) {
    selectedUser = cellViewModels[indexPath.row]
    
    if let selected = selectedUser {
      profileViewModel = ProfileViewModel(userName: selected.userName, id: selected.id)
    }
    
  }

  func fetchUsers(completion: @escaping (Error?) -> Void) {
    NetworkManager.shared.fetchUsers { (result) in
      switch result {
      case .failure(let error):
        completion(error)

      case .success(let users):
        if let lastUser = users.last {
          self.lastUserID = lastUser.id
        }

        self.cellViewModels = users.enumerated().map { (index, element: GitHubUser) in
          return UserTableCellViewModel(user: element, index: index)
        }


        completion(nil)
      }

    }
  }

  func fetchMoreUsers(completion: @escaping (Error?) -> Void) {
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

}


protocol CellItemable {
  var userName: String { get set }
  var id: Int16 { get set }
  
  func cellInstance(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
  var cellType: CellType { get set }

}

public enum CellType {
  case note
  case normal
  case inverted
}

