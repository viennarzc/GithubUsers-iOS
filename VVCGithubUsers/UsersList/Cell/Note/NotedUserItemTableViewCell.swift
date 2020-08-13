//
//  NotedUserItemTableViewCell.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/13/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import UIKit

class NotedUserItemTableViewCell: UITableViewCell, Notable {
  func setContainerBorder() {
    container.layer.borderColor = UIColor.separator.cgColor
    container.layer.borderWidth = 1
    container.layer.cornerRadius = 5
  }
  

  @IBOutlet weak var container: UIView!
  var imageURL: URL?
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userDetailsLabel: UILabel!
  @IBOutlet weak var avatarView: UIImageView!
  
  func update() {
    guard let vm = viewModel, let url = URL(string: vm.avatarUrl) else { return }
    self.imageURL = url

    // retrieves image if already available in cache
    if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
      self.avatarView.image = imageFromCache
      return
    }

    //load image
    NetworkManager.shared.loadImages(with: url) { (image, error) in
      if error != nil {
        return
      }

      DispatchQueue.main.async(execute: {

        if let image = image {
          imageCache.setObject(image, forKey: url as AnyObject)
        }

        if self.imageURL == url {
          self.avatarView.image = image
        }

      })

    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    //we set to default to avoid images being reused in other cells
    avatarView.image = UIImage(systemName: "person.circle")

  }

  var viewModel: UserTableCellViewModel? {
    didSet {
      update()
    }
  }

  var hasNotes: Bool = true

  func setupUI() {
    let paperClip = UIImage.init(systemName: "rectangle.and.paperclip")

    let imageView = UIImageView(image: paperClip)

    self.accessoryView = imageView
    backgroundColor = .clear
    setContainerBorder()
    
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
