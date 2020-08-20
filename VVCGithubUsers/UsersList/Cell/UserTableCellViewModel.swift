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
  var id: Int64

  var userName: String
  var details: String
  
  internal var cellType: CellType
  
  let avatarUrl: String

  init(user: GitHubUser, index: Int) {
    self.userName = user.login
    self.avatarUrl = user.avatarURL
    self.id = user.id
    self.details = user.type.capitalized
    
    
    let i = index + 1

    cellType = .normal

    if user.hasNotes {
      cellType = .note
    } else if i.isMultiple(of: 4) {
      cellType = .inverted
    }
  }

  func cellInstance(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
    switch cellType {
      
    case .inverted:
      let c = tableView.dequeueReusableCell(withIdentifier: InvertedUserItemTableViewCell.reuseIdentifierString, for: indexPath) as! InvertedUserItemTableViewCell
      c.viewModel = self
      return c
      
    case .normal:
      let c = tableView.dequeueReusableCell(withIdentifier: UserItemTableViewCell.reuseIdentifierString, for: indexPath) as! UserItemTableViewCell
      c.viewModel = self
      return c
      
    case .note:
      let c = tableView.dequeueReusableCell(withIdentifier: NotedUserItemTableViewCell.reuseIdentifierString, for: indexPath) as! NotedUserItemTableViewCell
      c.viewModel = self
      return c
    }

  }




}
