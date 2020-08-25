//
//  UIViewControllerExtensions.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/25/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import UIKit
extension UIViewController {
  func presentErrorAlert(with description: String) {
    let alertVC = UIAlertController(
      title: "Something is Wrong ",
      message: description,
      preferredStyle: .alert)

    let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (_) in
      alertVC.dismiss(animated: true, completion: nil)
    }
    alertVC.addAction(dismissAction)

    present(alertVC, animated: true, completion: nil)
    
  }

}
