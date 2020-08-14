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
  @IBOutlet weak var textView: UITextView!
  

  var viewModel: ProfileViewModel? {
    didSet {
      fetch()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    textView.text = "Add Notes..."
    textView.textColor = .systemGray
    textView.delegate = self

  }

  func fetch() {
    viewModel?.fetchUserProfile { (error) in
      if let error = error {
        print(error)
        return
      }
      
      DispatchQueue.main.async {
        self.updateUI()
        
      }
      
      self.loadAvatar()
      
    }
  }
  
  func loadAvatar() {
    guard let vm = viewModel else { return }
    
    
    guard let userProfile = vm.userProfile,
      let url = URL(string: userProfile.avatarURL) else { return }
    
    NetworkManager.shared.loadImages(with: url) { (image, error) in
      if let error = error {
        print(error)
        return
      }
      
      DispatchQueue.main.async {
        self.userAvatar.image = image
      }
  
    }
  }

  func updateUI() {
    guard let vm = viewModel else { return }

    if let userProfile = vm.userProfile {
      followersLabel.text = "Followers: \(userProfile.followers)"
      followingLabel.text = "Following: \(userProfile.following)"
      userNameLabel.text = "name: \(userProfile.name)"
      companyLabel.text = "company: \(userProfile.company ?? "None")"
      blogLabel.text = "blog: \(userProfile.blog ?? "None")"
      navigationItem.title = userProfile.name
    }
    
    //navigation title
    

  }
}

extension ProfileViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    textView.text = nil
    textView.textColor = .label
  }
}

