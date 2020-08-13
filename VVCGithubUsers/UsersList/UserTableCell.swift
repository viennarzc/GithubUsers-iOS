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
  
}

protocol Normal: UserTableCell {
  
}

protocol Notable: UserTableCell {
  var hasNotes: Bool { get set}
}

protocol Invertable: UserTableCell {
  var isInverted: Bool { get set }
}
