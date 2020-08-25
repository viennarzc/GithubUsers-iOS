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

  override func prepareForReuse() {
    super.prepareForReuse()

    //we set to default to avoid images being reused in other cells
    avatarView.image = nil

  }

  //MARK: - Methods

  func saveImageToDisk(_ image: UIImage, fileName: String) {
    ImageStoreManager.shared.saveToDisk(image, fileName: fileName)
  }
  
  func setContainerBorder() {
    container.layer.borderColor = UIColor.separator.cgColor
    container.layer.borderWidth = 1
    container.layer.cornerRadius = 5
  }

  func update() {
    guard let vm = viewModel, let url = URL(string: vm.avatarUrl) else { return }

    imageURL = url
    userNameLabel.text = vm.userName.capitalized
    userDetailsLabel.text = vm.details

    // retrieves image if already available in disk
    if let image = ImageStoreManager.shared.getImageFromDisk(of: vm.userName) {
      self.avatarView.image = image
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

        if self.imageURL == url, let img = image {
          self.avatarView.image = img
          self.saveImageToDisk(img, fileName: vm.userName)
        }

      })

    }


  }


  func setupUI() {
    avatarView.layer.cornerRadius = avatarView.frame.width / 2
    backgroundColor = .clear
    setContainerBorder()
  }


  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
