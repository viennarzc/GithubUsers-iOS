//
//  UserTableCell.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/13/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation
import UIKit


protocol UserTableCell {
  func setupUI()
  func update()
  var viewModel: UserTableCellViewModel? { get set }
  func setContainerBorder()
}

protocol ImageStoring {
  func saveImageToDisk(_ image: UIImage, fileName: String)
}

protocol Normal: UserTableCell, ImageStoring {
  
}

protocol Notable: UserTableCell, ImageStoring {

}

protocol Invertable: UserTableCell, ImageStoring {

}
