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

  init() {

  }

  func fetchUsers(completion: @escaping (Error?) -> Void) {
    NetworkManager.shared.fetchUsers { (result) in
      switch result {
      case .failure(let error):
        print(error)
        completion(error)
        
      case .success(let users):
        
        completion(nil)
        self.cellViewModels = users.enumerated().map { (index, element: GitHubUser) in
          return UserTableCellViewModel(user: element, index: index)
        }

      }
    }
  }

}


protocol CellItemable {
  func cellInstance(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
  var cellType: CellType { get set }

}

public enum CellType {
  case note
  case normal
  case inverted
}

