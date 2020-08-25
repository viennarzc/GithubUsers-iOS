//
//  ProfileTableViewController.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/25/20.
//  Copyright © 2020 VVC. All rights reserved.
//
import UIKit

class ProfileTableViewController: UITableViewController {
  
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
    
    textView.delegate = self
      textView.addDoneKeyboardToolbarButton()
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

    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
//    self.loadAvatar()
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
      textView.text = userProfile.notes
    }
  }
  
  @IBAction func didTapSaveNotes(_ sender: Any) {
    guard let vm = viewModel, let text = textView.text else { return }
    
    vm.saveInPrivateQueue(notes: text) { (error) in
      if let error = error {
        print(error)
        
        return
      }
      
      self.presentNotesSavedAlert()
    }
    
    vm.updateUserHasNotes { (error) in
      if let error = error {
        print(error)
      }
    }
  }
  
  /// Presents Purchase alert
  private func presentNotesSavedAlert() {

    let alertVC = UIAlertController(
      title: nil,
      message: "Notes saved!",
      preferredStyle: .alert)

    let dismissAction = UIAlertAction(title: "Awesome!", style: .default) { (_) in
      alertVC.dismiss(animated: true, completion: nil)
    }
    alertVC.addAction(dismissAction)

    present(alertVC, animated: true, completion: nil)
  }
  
  
}


extension ProfileTableViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
  
    textView.textColor = .label
  }
  
  func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
    return true
  }
}
