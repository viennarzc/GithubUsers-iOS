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

  @IBOutlet weak var followShimmerView: UIView!
  @IBOutlet weak var nameLoader: UIView!
  @IBOutlet weak var companyLoader: UIView!
  @IBOutlet weak var blogLoader: UIView!
  
  private var tableHeader = ProfileTableHeader(
    frame: CGRect(
      x: 0,
      y: 0,
      width: UIScreen.main.bounds.width,
      height: 250))

  var viewModel: ProfileViewModel? {
    didSet {
      fetch()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.tableHeaderView = tableHeader
    textView.delegate = self
    textView.addDoneKeyboardToolbarButton()
    
    showShimmerLoader()

  }
  
  private func showShimmerLoader() {
    followShimmerView.startShimmeringAnimation()
    nameLoader.startShimmeringAnimation(animationSpeed: 2, direction: .leftToRight, repeatCount: MAXFLOAT)
    companyLoader.startShimmeringAnimation(animationSpeed: 2, direction: .leftToRight, repeatCount: MAXFLOAT)
    blogLoader.startShimmeringAnimation(animationSpeed: 2, direction: .leftToRight, repeatCount: MAXFLOAT)
  }
  
  private func stopShimmerLoader() {
    followShimmerView.stopShimmeringAnimation()
    nameLoader.stopShimmeringAnimation()
    companyLoader.stopShimmeringAnimation()
    blogLoader.stopShimmeringAnimation()
    tableHeader.avatarView.stopShimmeringAnimation()
  }

  func fetch() {

    viewModel?.fetchUserProfile { (error) in
      if let error = error {
        
        DispatchQueue.main.async {
          self.presentErrorAlert(with: error.localizedDescription)
          self.stopShimmerLoader()
        }
        
        return
      }

      DispatchQueue.main.async {
        self.updateUI()
        self.loadAvatar()
        self.stopShimmerLoader()
      }

    }
  }

  func loadAvatar() {
    guard let vm = viewModel else { return }

    // retrieves image if already available in cache
    if let userProfile = vm.userProfile,
      let image = ImageStoreManager.shared.getImageFromDisk(of: userProfile.login) {
      tableHeader.image = image
      return
    }

    guard let userProfile = vm.userProfile,
      let url = URL(string: userProfile.avatarURL) else { return }

    NetworkManager.shared.loadImages(with: url) { (image, error) in
      if let error = error {
        self.presentErrorAlert(with: error.localizedDescription)
        return
      }

      DispatchQueue.main.async {
        self.tableHeader.image = image

      }

    }
  }


  func updateUI() {
    guard let vm = viewModel else { return }

    if let userProfile = vm.userProfile {
      followersLabel.text = "Followers: \(userProfile.followers)"
      followingLabel.text = "Following: \(userProfile.following)"
      userNameLabel.text = "name: \(userProfile.name ?? "No Name..shrouded with mystery")"
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
        self.presentErrorAlert(with: error.localizedDescription)

        return
      }

      self.presentNotesSavedAlert()
    }

    vm.updateUserHasNotes { (error) in
      if let error = error {
        self.presentErrorAlert(with: error.localizedDescription)
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

enum MyError: Error {
    case first(message: String)
    case unknown(message: String)

    var localizedDescription: String { return "Error" }
}


