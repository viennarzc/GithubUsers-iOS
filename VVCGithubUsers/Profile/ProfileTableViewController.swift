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

  private var tableHeader = ProfileTableHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250))

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

  }

  func fetch() {

    viewModel?.fetchUserProfile { (error) in
      if let error = error {
        print(error)
        return
      }

      DispatchQueue.main.async {
        self.updateUI()
        self.loadAvatar()
      }

    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

//    self.loadAvatar()
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
        print(error)
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

enum MyError: Error {
    case first(message: String)
    case second(message: String)

    var localizedDescription: String { return "Error" }
}


extension UITextView {
  func addDoneKeyboardToolbarButton() {
    let toolBar = UIToolbar()
    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonTapped))
    toolBar.barStyle = .default
    toolBar.sizeToFit()
    
    toolBar.setItems([space, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    
    self.inputAccessoryView = toolBar
  }
  
  @objc
  private func doneButtonTapped() {
    self.resignFirstResponder()
  }
}
