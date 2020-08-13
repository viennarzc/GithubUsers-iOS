//
//  UserItemTableViewCell.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/12/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import UIKit

class UserItemTableViewCell: UITableViewCell, Normal {
  @IBOutlet weak var avatarView: UIImageView!
  @IBOutlet weak var userDetailsLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  
  var imageURL: URL?
  
  var viewModel: UserTableCellViewModel? {
    didSet {
      update()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setupUI()
  }
  
  func update() {
    guard let vm = viewModel, let url = URL(string: vm.avatarUrl) else { return }
    NetworkManager.shared.loadImages(with: url) { (image, error) in
      if error != nil {
        return
      }
      
      self.avatarView.image = image
    }
    
    
    userNameLabel.text = vm.userName.capitalized
    userDetailsLabel.text = "details"
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


