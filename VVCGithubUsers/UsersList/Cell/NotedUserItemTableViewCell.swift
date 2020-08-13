//
//  NotedUserItemTableViewCell.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/13/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import UIKit

class NotedUserItemTableViewCell: UITableViewCell, Notable {
  @IBOutlet weak var avatarView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userDetailsLabel: UILabel!
  
  var hasNotes: Bool = true
  
  func setupUI() {
    let paperClip = UIImage.init(systemName: "rectangle.and.paperclip")
    
    let imageView = UIImageView(image: paperClip)
    
    self.accessoryView = imageView
    
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    setupUI()
  }
  

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
