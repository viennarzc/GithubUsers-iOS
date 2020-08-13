//
//  UserTableCellViewModel.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/13/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation
import UIKit

struct UserTableCellViewModel: CellItemable {
  var cellType: CellType

  let userName: String
  let hasNotes: Bool
  let isInverted: Bool = false

  init(user: GitHubUser, index: Int) {
    self.userName = user.login
    self.hasNotes = user.hasNotes

    cellType = .normal

    if user.hasNotes {
      cellType = .note
    } else if index.isMultiple(of: 4) {
      cellType = .inverted
    }
  }

  func cellInstance(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
    switch cellType {
    case .inverted:
      return tableView.dequeueReusableCell(withIdentifier: UserItemTableViewCell.reuseIdentifierString, for: indexPath)
    case .normal:
      return tableView.dequeueReusableCell(withIdentifier: UserItemTableViewCell.reuseIdentifierString, for: indexPath)
    case .note:
      return tableView.dequeueReusableCell(withIdentifier: NotedUserItemTableViewCell.reuseIdentifierString, for: indexPath)
    }

  }


}
