//
//  InvertedUserItemTableViewCell.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/13/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import UIKit

class InvertedUserItemTableViewCell: UITableViewCell, Invertable {
  
  @IBOutlet weak var avatarView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userDetailsLabel: UILabel!
  @IBOutlet weak var container: UIView!
  
  var imageURL: URL?

  var viewModel: UserTableCellViewModel? {
    didSet {
      update()
    }
  }

  var isInverted: Bool = true
  
  //MARK: - Life Cycle


  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    setupUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    //we set to default to avoid images being reused in other cells
    avatarView.image = nil
  }
  
  //MARK: - Custom Methods

  func setContainerBorder() {
    container.layer.borderColor = UIColor.separator.cgColor
    container.layer.borderWidth = 1
    container.layer.cornerRadius = 5
  }
  
  
  func update() {

    guard let vm = viewModel,
      let url = URL(string: vm.avatarUrl) else { return }
    
    imageURL = url
    userNameLabel.text = vm.userName.capitalized
    userDetailsLabel.text = vm.details

    // retrieves image if already available in cache
    if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
      self.avatarView.image = self.invertColor(of: imageFromCache)
      return
    }

    NetworkManager.shared.loadImages(with: url) { (image, error) in
      if error != nil {
        return
      }

      DispatchQueue.main.async(execute: {

        if let image = image {
          imageCache.setObject(image, forKey: url as AnyObject)
        }

        if self.imageURL == url, let img = image {
          self.avatarView.image = self.invertColor(of: img)
        }

      })

    }

    userNameLabel.text = vm.userName.capitalized
    userDetailsLabel.text = vm.details
  }

  func invertColor(of image: UIImage) -> UIImage {
    if let image = CIImage(image: image), let filter = CIFilter(name: "CIColorInvert") {
      filter.setValue(image, forKey: kCIInputImageKey)
      let inverted = UIImage(ciImage: filter.outputImage ?? image)
      return inverted
    }

    return image
  }

  func setupUI() {
    avatarView.layer.cornerRadius = avatarView.frame.width / 2

    setContainerBorder()
    backgroundColor = .clear
  }
  

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
