//
//  UserItemTableViewCell.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/12/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import UIKit

class UserItemTableViewCell: UITableViewCell, Normal {
  func setContainerBorder() {
    container.layer.borderColor = UIColor.systemGray6.cgColor
    container.layer.borderWidth = 2
    container.layer.cornerRadius = 5
  }
  
  @IBOutlet weak var avatarView: UIImageView!
  @IBOutlet weak var userDetailsLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var container: UIView!
  
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

    userNameLabel.text = vm.userName.capitalized
    userDetailsLabel.text = "details"
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    //we set to default to avoid images being reused in other cells
    avatarView.image = nil

  }

  func setupUI() {
    avatarView.layer.cornerRadius = avatarView.frame.width / 2
    setContainerBorder()
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


extension UIView {
  /// Add Dropshadow
  /// - Parameter scale: Set if should do rasterization scale
  func dropShadow(scale: Bool = true, shadowColor: UIColor = .systemGray5) {
    layer.masksToBounds = false
    layer.shadowColor = shadowColor.cgColor
    layer.shadowOpacity = 0.3
    layer.shadowOffset = .zero
    layer.shadowRadius = 10
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}

