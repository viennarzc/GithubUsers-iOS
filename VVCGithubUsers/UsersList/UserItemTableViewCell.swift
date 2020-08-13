//
//  UserItemTableViewCell.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/12/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import UIKit

class UserItemTableViewCell: UITableViewCell {
  @IBOutlet weak var avatarView: UIImageView!
  @IBOutlet weak var userDetailsLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setupUI()
  }

  func setupUI() {
    avatarView.layer.cornerRadius = avatarView.frame.width / 2
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}

extension UITableViewCell {
  static var nib: UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }
  
  ///Identifier to be use for table header view
  class var reuseIdentifierString: String {
     return String(describing: self)
   }
   
}


