//
//  ProfileTableHeader.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/25/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import UIKit

class ProfileTableHeader: UIView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var avatarView: UIImageView!
  
  var image: UIImage? {
    didSet {
      self.avatarView.image = image
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    Bundle.main.loadNibNamed("ProfileTableHeader", owner: self, options: nil)
    
    addSubview(contentView)
    
    contentView.translatesAutoresizingMaskIntoConstraints = true
    contentView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
    
    guard let image = image else { return }
    
    self.avatarView.image = image
  }

}
