//
//  UITextViewExtensions.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/25/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import UIKit

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
