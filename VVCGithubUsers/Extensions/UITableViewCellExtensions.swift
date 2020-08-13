//
//  UITableViewCellExtensions.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/13/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
  static var nib: UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }

  ///Identifier to be use for table header view
  class var reuseIdentifierString: String {
    return String(describing: self)
  }

}

