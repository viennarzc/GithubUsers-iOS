//
//  ProfileViewController.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/14/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var userAvatar: UIImageView!
  @IBOutlet weak var followersLabel: UILabel!
  @IBOutlet weak var followingLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var companyLabel: UILabel!
  @IBOutlet weak var blogLabel: UILabel!
  
  
  var viewModel: ProfileViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel?.fetchUserProfile { (error) in
      if let error = error {
        print(error)
        return
      }
      
      self.updateUI()
    }
    
  }
  
  func updateUI() {
    guard let vm = viewModel else { return }
  
    if let userProfile = vm.userProfile {
      followersLabel.text = "\(userProfile.followers)"
      followingLabel.text = "\(userProfile.following)"
      userNameLabel.text = userProfile.name
    }
    
    
  }
}


