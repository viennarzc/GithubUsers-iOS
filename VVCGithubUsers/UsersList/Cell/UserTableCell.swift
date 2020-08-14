//
//  UserTableCell.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/13/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation

protocol UserTableCell {
  func setupUI()
  func update()
  var viewModel: UserTableCellViewModel? { get set }
  func setContainerBorder()
}

protocol Normal: UserTableCell {
  
}

protocol Notable: UserTableCell {

}

protocol Invertable: UserTableCell {

}
