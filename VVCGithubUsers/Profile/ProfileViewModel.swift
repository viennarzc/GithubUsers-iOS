//
//  ProfileViewModel.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/14/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation

class ProfileViewModel {
  private let userName: String
  
  private(set) var userProfile: UserProfile?
  
  init(userName: String) {
    self.userName = userName
  }
  
  func fetchUserProfile(completion: @escaping (Error?) -> Void) {
    NetworkManager.shared.fetchUser(with: userName) { (result) in
      switch result {
      case .failure(let error):
        completion(error)
      case .success(let user):
        self.userProfile = user
        completion(nil)
      }
    }
  }
}
